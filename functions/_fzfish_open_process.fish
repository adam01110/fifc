function _fzfish_open_process -d "Open the tree view of the selected process (procs only)"
    set -l pids (_fzfish_parse_pid "$fzfish_candidate" "$fzfish_commandline")

    if type -q procs
        procs --color=always --tree --pager=always $fzfish_procs_opts $pids
    end
end
