function _fifc_source_files -d "Return a command to recursively find files"
    set -l raw_path (_fifc_path_to_complete)
    set -l escaped_path (string escape -- $raw_path)
    set -l path_type (string match -rq '/$' -- "$raw_path"; and echo directory; or echo string)
    set -l hidden (string match "*." "$raw_path")

    # Clear query when token is a directory path — the source command already
    # scopes to this path, so the prefix would break --exact substring matching
    # (e.g. typing "db" with query "../db" won't match "../connect-plus-db/").
    if string match --quiet -- '~*' "$fifc_query"; or string match --quiet -- '*/' "$fifc_query"
        set -e fifc_query
    end

    if test "$path_type" != directory
        echo _fifc_parse_complist
        return
    end

    if type -q fd
        if _fifc_test_version (fd --version) -ge "8.3.0"
            set fd_custom_opts --strip-cwd-prefix
        end

        set -l hidden_flag
        if set -q fifc_show_hidden; and test "$fifc_show_hidden" = true
            set hidden_flag --hidden
        else if test -n "$hidden"; or test "$raw_path" = "."
            set hidden_flag --hidden
        end

        if test "$raw_path" = "$PWD/"
            echo "fd . $fifc_fd_opts --color=always $hidden_flag $fd_custom_opts"
        else if test "$raw_path" = "."
            echo "fd . $fifc_fd_opts --color=always $hidden_flag $fd_custom_opts"
        else if test -n "$hidden"
            echo "fd . $fifc_fd_opts --color=always $hidden_flag -- $escaped_path"
        else
            echo "fd . $fifc_fd_opts --color=always $hidden_flag -- $escaped_path"
        end
    else if test -n "$hidden"; or set -q fifc_show_hidden; and test "$fifc_show_hidden" = true
        echo "find . $escaped_path $fifc_find_opts ! -path . -print 2>/dev/null | sed 's|^\./||'"
    else
        echo "find . $escaped_path $fifc_find_opts ! -path . ! -path '*/.*' -print 2>/dev/null | sed 's|^\./||'"
    end
end
