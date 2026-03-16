function type
    if test "$argv[1]" = -q; and test "$argv[2]" = procs
        return 0
    end

    builtin type $argv
end

function pgrep
    echo 101
    echo 202
end

function procs
    echo "procs:$argv"
end

set fzfish_commandline "pkill "
set fzfish_candidate fish

set actual (_fzfish_open_process)
@test "open process resolves pkill names with procs" "$actual" = "procs:--color=always --tree --pager=always 101 202"

functions -e type
functions -e pgrep
functions -e procs
set -e fzfish_commandline
set -e fzfish_candidate
