function _fzfish_action
    # Can be either "preview", "open" or "source"
    set -l action $argv[1]
    set -l comp $_fzfish_ordered_comp $_fzfish_unordered_comp
    set -l regex_val (string escape --style=regex -- "$argv[2]")
    # Escape '/' for sed processing
    set regex_val (string replace '/' '\/' --all "$regex_val")

    # Variables exposed to evaluated commands
    set -x fzfish_desc (sed -nr (printf 's/^%s[[:blank:]]+(.*)/\\\1/p' "$regex_val") $_fzfish_complist_path | string trim)
    set -x fzfish_candidate "$argv[2]"
    set -x fzfish_extracted (string match --regex --groups-only -- "$_fzfish_extract_regex" "$argv[2]")

    if test "$action" = preview
        set default_preview 1
        set fzfish_query "$argv[3]"

    else if test "$action" = open
        set fzfish_query "$argv[3]"

    else if test "$action" = source
        set default_source 1
    end

    for comp_name in $comp
        set -l condition_cmd
        set -l regex_cmd
        set -l valid 1
        if test -n "$$comp_name[1][1]"
            set condition_cmd "$$comp_name[1][1]"
        else
            set condition_cmd true
        end
        if test -n "$$comp_name[1][2]"
            set -l val (string escape -- "$fzfish_commandline")
            set regex_cmd "string match --regex --quiet -- '$$comp_name[1][2]' $val"
        else
            set regex_cmd true
        end

        if not eval "$condition_cmd; and $regex_cmd"
            set valid 0
            continue
        end

        set _fzfish_extract_regex "$$comp_name[1][7]"

        if test "$action" = preview; and test -n "$$comp_name[1][3]"
            eval $$comp_name[1][3]
            set default_preview 0
            break
        else if test "$action" = open; and test -n "$$comp_name[1][4]"
            eval $$comp_name[1][4]
            break
        else if test "$action" = source; and test -n "$$comp_name[1][5]"
            set -g _fzfish_default_source_fzf_opts $$comp_name[1][6]
            if functions "$$comp_name[1][5]" 1>/dev/null
                eval $$comp_name[1][5]
            else
                echo $$comp_name[1][5]
            end
            set default_source 0
            break
        end
    end

    # We are in preview mode, but nothing matched
    # fallback to fish description
    if test "$default_preview" = 1
        echo "$fzfish_desc"
    else if test "$default_source" = 1
        if set -q fzfish_wrap_default_preview; and test "$fzfish_wrap_default_preview" = true
            set -g _fzfish_default_source_fzf_opts '--preview-window "wrap"'
        end
        echo _fzfish_parse_complist
    end
end
