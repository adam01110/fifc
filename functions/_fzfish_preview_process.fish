function _fzfish_preview_process -d "Preview process informations"
    set -l pids (_fzfish_parse_pid "$fzfish_candidate" "$fzfish_commandline")

    set -l ps_pids (string join ',' $pids)
    set -l err_msg "\nThe process exited"

    if test -z "$ps_pids"
        set_color yellow
        echo -e "$err_msg"
        return 1
    end

    if type -q procs
        procs --color=always --tree $fzfish_procs_opts $pids
    else
        set -l ps_preview_fmt (string join ',' 'pid' 'ppid=PARENT' 'user' '%cpu' 'rss=RSS_IN_KB' 'start=START_TIME' 'command')
        ps -o "$ps_preview_fmt" -p "$ps_pids" 2>/dev/null
    end
    if not ps -p "$ps_pids" &>/dev/null
        set_color yellow
        echo -e "$err_msg"
    end
end
