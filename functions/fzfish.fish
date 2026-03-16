function __fzfish_check_flag -d "Check flag value for fzfish"
    switch $_flag_name
        case O order
            if not test 0 -lt $_flag_value
                echo "$_argparse_cmd: Order must be a positive integer"
                return 1
            end
            # Ensure regex is valid
        case r regex
            set -l out (string match --regex --quiet $_flag_value 2>&1 | string join '\n')
            if test -n "$out"
                echo -e "$_argparse_cmd:\n$out"
            end
    end
end

function fzfish -d "Add your own fish fzf completions"
    set -l option_spec 'n/condition=' 'p/preview=' 'o/open=' 's/source=' 'e/extract=' 'f/fzf-options=' h/help
    set -a option_spec 'r/regex=!__fzfish_check_flag' 'O/order=!__fzfish_check_flag'

    argparse --name fzfish $option_spec -- $argv

    if test "$status" != 0
        return 1
    end

    if test -n "$_flag_h"
        _fzfish_help
        return
    end

    if test \( -n "$_flag_n" -o -n "$_flag_r" \) \
            -a \( -z "$_flag_p" -a -z "$_flag_o" -a -z "$_flag_s" -a -z "$_flag_e" -a -z "$_flag_f" \)

        echo "fzfish: You have not specified any binding (preview, open, source or extract)"
        return 1
    end

    set _fzfish_comp_count (math $_fzfish_comp_count + 1)
    set -l count $_fzfish_comp_count
    # Ensure completion vars are empty before setting them
    set -e "_fzfish_comp_$count"
    set -gx "_fzfish_comp_$count"
    set -a "_fzfish_comp_$count" "$_flag_n"
    set -a "_fzfish_comp_$count" "$_flag_r"
    set -a "_fzfish_comp_$count" "$_flag_p"
    set -a "_fzfish_comp_$count" "$_flag_o"
    set -a "_fzfish_comp_$count" "$_flag_s"
    set -a "_fzfish_comp_$count" "$_flag_f"
    set -a "_fzfish_comp_$count" "$_flag_e"

    if test -z "$_flag_O"
        set -a _fzfish_unordered_comp "_fzfish_comp_$count"
    else
        set _fzfish_ordered_comp[$_flag_O] "_fzfish_comp_$count"
    end
end
