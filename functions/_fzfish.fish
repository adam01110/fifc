function _fzfish
    set -f --export SHELL (command --search fish)
    set -l result
    set -Ux _fzfish_extract_regex
    set -gx _fzfish_complist_path (string join '' (mktemp) "_fzfish")
    set -gx _fzfish_default_source_fzf_opts
    set -gx fzfish_extracted
    set -gx fzfish_commandline
    set -gx fzfish_token (commandline --current-token)
    set -gx fzfish_query "$fzfish_token"

    # Get commandline buffer
    if test "$argv" = ""
        set fzfish_commandline (commandline --cut-at-cursor)
    else
        set fzfish_commandline $argv
    end

    if _fzfish_test_version "$FISH_VERSION" -ge "3.4"
        set complete_opts --escape
    end

    complete -C $complete_opts -- "$fzfish_commandline" | string split '\n' >$_fzfish_complist_path

    set -gx fzfish_group (_fzfish_completion_group)
    set source_cmd (_fzfish_action source)

    set fzfish_safe_query (string unescape -- "$fzfish_query" | string escape --style=script)

    # Add case-insensitive flag if configured
    set -l case_flag
    if set -q fzfish_case_insensitive; and test "$fzfish_case_insensitive" = true
        set case_flag -i
    end

    set -l fzfish_history_dir "$HOME/.local/share/fzfish"
    mkdir -p "$fzfish_history_dir"

    set -l history_group "$fzfish_group"
    if test -z "$history_group"
        set history_group default
    end

    set -l fzf_output_path (string join '' (mktemp) "_fzfish_out")
    set -l source_output_path

    set -l fzf_cmd "
        _fzfish_launched_by_fzf=1 SHELL=fish fzf \
            -d \t \
            --exact \
            --tiebreak=length \
            --select-1 \
            --exit-0 \
            --ansi \
            --tabstop=4 \
            --multi \
            --reverse \
            --header '$header' \
            --preview '_fzfish_action preview {} {q}' \
            --bind='$fzfish_open_keybinding:execute(_fzfish_action open {} {q} &> /dev/tty)' \
            --query $fzfish_safe_query \
            --history=$fzfish_history_dir/fzf-history-$history_group \
            $case_flag \
            $_fzfish_default_source_fzf_opts \
            $fzfish_custom_fzf_opts"

    if test "$fzfish_popup" = true
        set fzf_cmd "$fzf_cmd --height ~$fzfish_popup_height --border"
    end

    if command tail --pid=$fish_pid -n 0 /dev/null >/dev/null 2>/dev/null
        set -l source_output_path (string join '' (mktemp) "_fzfish_source")
        command touch $source_output_path

        fish -c "$source_cmd" >$source_output_path &
        set -l source_pid $last_pid
        disown $source_pid 2>/dev/null

        # Keep the source producer detached from the interactive shell so fzf can
        # return immediately even if the filesystem walk stalls after selection.
        tail --pid=$source_pid -n +1 -f $source_output_path | eval $fzf_cmd >$fzf_output_path
        command kill $source_pid 2>/dev/null
    else
        set -l cmd (string join -- " | " $source_cmd $fzf_cmd)
        # We use eval hack because wrapping source command
        # inside a function cause some delay before fzf to show up
        eval $cmd >$fzf_output_path
    end

    while read -l token
        # don't escape '~' for path, `$` for environ
        if string match --quiet '~*' -- $token
            set -a result (string join -- "" "~" (string sub --start 2 -- $token | string escape))
        else if string match --quiet '$*' -- $token
            set -a result (string join -- "" "\$" (string sub --start 2 -- $token | string escape))
        else
            set -a result (string escape --no-quoted -- $token)
        end
        # Perform extraction if needed
        if test -n "$_fzfish_extract_regex"
            set result[-1] (string match --regex --groups-only -- "$_fzfish_extract_regex" "$token")
        end
    end <$fzf_output_path

    # Add space trailing space only if:
    # - there is no trailing space already present
    # - Result is not a directory
    # We need to unescape $result for directory test as we escaped it before
    if test (count $result) -eq 1
        set -l result_path (_fzfish_expand_tilde (string unescape -- $result[1]))
        if not test -d "$result_path"
            set -l buffer (string split -- "$fzfish_commandline" (commandline -b))
            if not string match -- ' *' "$buffer[2]"
                set -a result ''
            end
        end
    end

    if test -n "$result"
        commandline --replace --current-token -- (string join -- ' ' $result)
    end

    commandline --function repaint

    command $fzfish_rm_cmd $_fzfish_complist_path
    command $fzfish_rm_cmd $fzf_output_path $source_output_path 2>/dev/null
    # Clean state
    set -e _fzfish_extract_regex
    set -e _fzfish_default_source_fzf_opts
    set -e _fzfish_complist_path
    set -e fzfish_token
    set -e fzfish_group
    set -e fzfish_extracted
    set -e fzfish_candidate
    set -e fzfish_commandline
    set -e fzfish_query
end
