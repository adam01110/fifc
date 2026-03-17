# Private
set -gx _fzfish_comp_count 0
set -gx _fzfish_unordered_comp
set -gx _fzfish_ordered_comp

function _fzfish_set_bindings --on-variable fish_key_bindings

    # Keybindings
    set -qU fzfish_keybinding
    or set -U fzfish_keybinding \t

    set -qU fzfish_open_keybinding
    or set -U fzfish_open_keybinding ctrl-o

    set -qU fzfish_rm_cmd
    or set -U fzfish_rm_cmd rm

    set -qU fzfish_custom_fzf_opts
    or set -U fzfish_custom_fzf_opts

    set -q fzfish_depth_increase_keybindings
    or set -U fzfish_depth_increase_keybindings alt-right ctrl-l

    set -q fzfish_depth_decrease_keybindings
    or set -U fzfish_depth_decrease_keybindings alt-left ctrl-h

    set -q fzfish_depth_direct_keybindings
    or set -U fzfish_depth_direct_keybindings alt-1 alt-2 alt-3 alt-4 alt-5 alt-6 alt-7 alt-8 alt-9

    for mode in default insert
        bind --mode $mode $fzfish_keybinding _fzfish
    end

    # Build depth-control fzf options (default: depth 1)
    set -l _base "--tiebreak=length,index --prompt='d:1> '"
    set -l _inc_header (string join '/' $fzfish_depth_increase_keybindings)
    set -l _dec_header (string join '/' $fzfish_depth_decrease_keybindings)
    set -l _direct_header (string join '/' $fzfish_depth_direct_keybindings)
    set -l _base "$_base --header='-:$_dec_header | +:$_inc_header | set:$_direct_header'"

    set -l _dir "$_base"
    for _key in $fzfish_depth_increase_keybindings
        set _dir "$_dir --bind='$_key:transform(_fzfish_depth_transform +1 d)'"
    end
    for _key in $fzfish_depth_decrease_keybindings
        set _dir "$_dir --bind='$_key:transform(_fzfish_depth_transform -1 d)'"
    end
    for _n in (seq (count $fzfish_depth_direct_keybindings))
        set -l _key $fzfish_depth_direct_keybindings[$_n]
        set _dir "$_dir --bind='$_key:transform(_fzfish_depth_transform $_n d)'"
    end

    set -l _file "$_base"
    for _key in $fzfish_depth_increase_keybindings
        set _file "$_file --bind='$_key:transform(_fzfish_depth_transform +1)'"
    end
    for _key in $fzfish_depth_decrease_keybindings
        set _file "$_file --bind='$_key:transform(_fzfish_depth_transform -1)'"
    end
    for _n in (seq (count $fzfish_depth_direct_keybindings))
        set -l _key $fzfish_depth_direct_keybindings[$_n]
        set _file "$_file --bind='$_key:transform(_fzfish_depth_transform $_n)'"
    end

    # Set source rules
    fzfish \
        -n 'test "$fzfish_group" = "directories"' \
        -s _fzfish_source_directories \
        -f $_dir
    fzfish \
        -n 'test "$fzfish_group" = "files"' \
        -s _fzfish_source_files \
        -f $_file
    fzfish \
        -n 'test "$fzfish_group" = processes' \
        -s 'ps -ax -o pid=,command='
end

if status is-interactive
    _fzfish_set_bindings
end

# Load fzfish preview rules only when fish is launched fzf
if set -q _fzfish_launched_by_fzf
    # Builtin preview/open commands
    fzfish \
        -n 'test "$fzfish_group" = "options"' \
        -p _fzfish_preview_opt \
        -o _fzfish_open_opt
    fzfish \
        -n 'test \( -n "$fzfish_desc" -o -z "$fzfish_commandline" \); and type -q -f -- "$fzfish_candidate"' \
        -r '^(?!\\w+\\h+)' \
        -p _fzfish_preview_cmd \
        -o _fzfish_open_cmd
    fzfish \
        -n 'test -n "$fzfish_desc" -o -z "$fzfish_commandline"' \
        -r '^(functions)?\\h+' \
        -p _fzfish_preview_fn \
        -o _fzfish_open_fn
    fzfish \
        -n 'test -f "$fzfish_candidate"' \
        -p _fzfish_preview_file \
        -o _fzfish_open_file
    fzfish \
        -n 'test -d "$fzfish_candidate"' \
        -p _fzfish_preview_dir
    fzfish \
        -n 'begin; test "$fzfish_group" = processes; and ps -p (_fzfish_parse_pid "$fzfish_candidate") >/dev/null 2>/dev/null; end; or begin; string match --regex --quiet -- "(^|.*\\h)pkill(\\h|\\$)" "$fzfish_commandline"; and pgrep -- "$fzfish_candidate" >/dev/null 2>/dev/null; end' \
        -p _fzfish_preview_process \
        -o _fzfish_open_process \
        -e '^\\h*([0-9]+)'
end

# Fisher
function _fzfish_uninstall --on-event fzfish_uninstall
end
