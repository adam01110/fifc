function _fzfish_source_files -d "Return a command to recursively find files"
    set -l raw_path (_fzfish_path_to_complete)
    set -l escaped_path (string escape -- $raw_path)
    set -l path_type (string match -rq '/$' -- "$raw_path"; and echo directory; or echo string)
    set -l hidden (string match "*." "$raw_path")

    # Clear query when token is a directory path - the source command already
    # scopes to this path, so the prefix would break --exact substring matching.
    if string match --quiet -- '~*' "$fzfish_query"; or string match --quiet -- '*/' "$fzfish_query"
        set -e fzfish_query
    end

    if test "$path_type" != directory
        echo _fzfish_parse_complist
        return
    end

    if type -q fd
        if _fzfish_test_version (fd --version) -ge "8.3.0"
            set fd_custom_opts --strip-cwd-prefix
        end

        set -l hidden_flag
        if set -q fzfish_show_hidden; and test "$fzfish_show_hidden" = true
            set hidden_flag --hidden
        else if test -n "$hidden"; or test "$raw_path" = "."
            set hidden_flag --hidden
        end

        set -l fd_base_opts $fzfish_fd_opts --max-depth 1 --color=always --no-ignore $hidden_flag $fd_custom_opts

        if test "$raw_path" = "$PWD/"
            echo "fd . $fd_base_opts"
        else if test "$raw_path" = "."
            echo "fd . $fd_base_opts"
        else
            echo "fd . $fd_base_opts -- $escaped_path"
        end
    else if test -n "$hidden"; or set -q fzfish_show_hidden; and test "$fzfish_show_hidden" = true
        echo "find . $escaped_path -maxdepth 1 $fzfish_find_opts ! -path . -print 2>/dev/null | sed 's|^\./||'"
    else
        echo "find . $escaped_path -maxdepth 1 $fzfish_find_opts ! -path . ! -path '*/.*' -print 2>/dev/null | sed 's|^\./||'"
    end
end
