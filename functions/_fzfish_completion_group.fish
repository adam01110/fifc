function _fzfish_completion_group -d "Determine completion group"
    set -l path_candidate (_fzfish_path_to_complete)
    set -l complist (string escape -- (_fzfish_expand_tilde (_fzfish_parse_complist)))
    set dir_test "test "(string join -- " -a " "-d "$complist)

    if test -d "$path_candidate"
        if eval "$dir_test"
            echo directories
            return
        end

        # When complist is big, avoid calling ls with all arguments if first is neither a file nor a directory
        if echo $complist | xargs ls -d -- &>/dev/null
            echo files
            return
        end
    end

    if string match --regex --quiet -- '\h+\-+\h*$' "$fzfish_commandline"
        set -e fzfish_query
        echo options
        return
    end

    if string join -- '' $complist | string match --regex --quiet '^[0-9]+$'
        echo processes
    end
end
