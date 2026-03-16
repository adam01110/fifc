function _fzfish_reload_depth -d "Reload file/directory listing at specific depth"
    set -l depth $argv[1]
    set -l type_flag $argv[2]

    set -l raw_path (_fzfish_path_to_complete)
    set -l escaped_path (string escape -- $raw_path)
    set -l hidden (string match "*." "$raw_path")

    set -l hidden_flag
    if set -q fzfish_show_hidden; and test "$fzfish_show_hidden" = true
        set hidden_flag --hidden
    else if test -n "$hidden"; or test "$raw_path" = "."
        set hidden_flag --hidden
    end

    if type -q fd
        set -l fd_cmd (command -v fdfind || command -v fd)
        set -l fd_custom_opts
        if _fzfish_test_version ($fd_cmd --version) -ge "8.3.0"
            set fd_custom_opts --strip-cwd-prefix
        end

        set -l type_opt
        if test -n "$type_flag"
            set type_opt -t $type_flag
        end

        set -l fd_base_opts $fzfish_fd_opts $type_opt --max-depth $depth --color=always --no-ignore $hidden_flag $fd_custom_opts

        if test "$raw_path" = "$PWD/"; or test "$raw_path" = "."
            $fd_cmd . $fd_base_opts
        else
            $fd_cmd . $fd_base_opts -- $escaped_path
        end
    else
        set -l find_type_opt
        if test "$type_flag" = d
            set find_type_opt -type d
        end

        if set -q fzfish_show_hidden; and test "$fzfish_show_hidden" = true
            find . $escaped_path -maxdepth $depth $fzfish_find_opts $find_type_opt \
                ! -path . -print 2>/dev/null | sed 's|^\./||'
        else if test -n "$hidden"
            find . $escaped_path -maxdepth $depth $fzfish_find_opts $find_type_opt \
                ! -path . -print 2>/dev/null | sed 's|^\./||'
        else
            find . $escaped_path -maxdepth $depth $fzfish_find_opts $find_type_opt \
                ! -path . ! -path '*/.*' -print 2>/dev/null | sed 's|^\./||'
        end
    end
end
