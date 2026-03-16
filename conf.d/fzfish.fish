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

    for mode in default insert
        bind --mode $mode $fzfish_keybinding _fzfish
    end

    # Build depth-control fzf options (default: depth 1)
    # Bindings: ctrl-j/k and alt-up/down step depth, alt-1..9 jump directly
    set -l _base "--tiebreak=length,index --prompt='d:1> '"
    set -l _base "$_base --header='ctrl-j/k | alt-up/down | alt-1..9 depth'"

    set -l _dir "$_base"
    set -l _dir "$_dir --bind='alt-down:transform(_fzfish_depth_transform +1 d)'"
    set -l _dir "$_dir --bind='alt-up:transform(_fzfish_depth_transform -1 d)'"
    set -l _dir "$_dir --bind='ctrl-j:transform(_fzfish_depth_transform +1 d)'"
    set -l _dir "$_dir --bind='ctrl-k:transform(_fzfish_depth_transform -1 d)'"
    for _n in 1 2 3 4 5 6 7 8 9
        set _dir "$_dir --bind='alt-$_n:transform(_fzfish_depth_transform $_n d)'"
    end

    set -l _file "$_base"
    set -l _file "$_file --bind='alt-down:transform(_fzfish_depth_transform +1)'"
    set -l _file "$_file --bind='alt-up:transform(_fzfish_depth_transform -1)'"
    set -l _file "$_file --bind='ctrl-j:transform(_fzfish_depth_transform +1)'"
    set -l _file "$_file --bind='ctrl-k:transform(_fzfish_depth_transform -1)'"
    for _n in 1 2 3 4 5 6 7 8 9
        set _file "$_file --bind='alt-$_n:transform(_fzfish_depth_transform $_n)'"
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
        -n 'begin; test "$fzfish_group" = processes; and ps -p (_fzfish_parse_pid "$fzfish_candidate") >/dev/null 2>/dev/null; end; or begin; string match --regex --quiet -- "(^|.*\\h)pkill(\\h|\\$)" "$fzfish_commandline"; and pgrep -- "$fzfish_candidate" >/dev/null 2>/dev/null; end' \
        -p _fzfish_preview_process \
        -o _fzfish_open_process \
        -e '^\\h*([0-9]+)'
end

# Fisher
function _fzfish_uninstall --on-event fzfish_uninstall
end
