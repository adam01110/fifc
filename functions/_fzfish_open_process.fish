function _fzfish_open_process -d "Open the tree view of the selected process (procs only)"
    set -l pids (_fzfish_parse_pid "$fzfish_candidate")

    if test -z "$pids"
        if string match --regex --quiet -- '(^|.*\h)pkill(\h|$)' "$fzfish_commandline"
            set pids (pgrep -- "$fzfish_candidate" 2>/dev/null)
        end
    end

    if type -q procs
        procs --color=always --tree --pager=always $fzfish_procs_opts $pids
    end
end
