function _fzfish_completion_group -d "Determine completion group"
    set -l path_candidate (_fzfish_path_to_complete)
    # Null means that either $path is empty or is not a directory
    set -l is_null (ls -A -- $path_candidate 2> /dev/null | string collect)
    set -l complist (string escape -- (_fzfish_expand_tilde (_fzfish_parse_complist)))
    # Directories
    set dir_test "test "(string join -- " -a " "-d "$complist)
    if test -n "$is_null"; and eval "$dir_test"
        echo directories
        # Files
        # When complist is big, avoid calling ls with all arguments if first is neither a file nor a directory
    else if test -n "$is_null"; and echo $complist | xargs ls -d -- &>/dev/null
        echo files
        # Options
    else if string match --regex --quiet -- '\h+\-+\h*$' $fzfish_commandline
        set -e fzfish_query
        echo options
        # PIDs
    else if string join -- '' $complist | string match --regex --quiet '^[0-9]+$'
        echo processes
    end
end
