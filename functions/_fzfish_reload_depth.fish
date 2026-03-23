function _fzfish_reload_depth -d "Reload file/directory listing at specific depth"
    set -l depth $argv[1]
    set -l type_flag $argv[2]
    set -l source_cmd (_fzfish_source_files $depth $type_flag false)

    if test "$source_cmd" = _fzfish_parse_complist
        if not set -q _fzfish_complist_path[1]; or test -z "$_fzfish_complist_path"; or not test -r "$_fzfish_complist_path"
            return 0
        end
    end

    eval $source_cmd
end
