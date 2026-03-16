function _fzfish_open_fn -d "Open a function definition using open file wrapper"
    set -l pathname (functions --details $fzfish_candidate 2>/dev/null)
    if test -f $pathname
        _fzfish_open_file $pathname
    end
end
