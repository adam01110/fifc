set curr_fzfish_unordered_comp $_fzfish_unordered_comp
set curr_fzfish_ordered_comp $_fzfish_ordered_comp
set _fzfish_complist_path (mktemp)

# Add unordered sources
set comp_1 'test "$any" = "1"' '^kill $' '' '' 'echo comp_1'
set comp_2 'test "$any" = "2"' '^ps -p $' '' '' 'echo comp_2'
set _fzfish_unordered_comp comp_1 comp_2

set fzfish_commandline "kill "
set any 1
set actual (_fzfish_action "source")
@test "source match first" "$actual" = "echo comp_1"

set fzfish_commandline "ps -p "
set any 2
set actual (_fzfish_action "source")
@test "source match second" "$actual" = "echo comp_2"

set fzfish_commandline "foo "
set actual (_fzfish_action "source")
@test "source fallback fish suggestions" "$actual" = _fzfish_parse_complist

set -e _fzfish_default_source_fzf_opts
set actual_default_wrap (begin
    set -e fzfish_wrap_default_preview
    _fzfish_action "source" >/dev/null
    echo -n "$_fzfish_default_source_fzf_opts"
end)
@test "source fallback wrap disabled by default" "$actual_default_wrap" = ""

set actual_enabled_wrap (begin
    set -gx fzfish_wrap_default_preview true
    _fzfish_action "source" >/dev/null
    echo -n "$_fzfish_default_source_fzf_opts"
end)
@test "source fallback wrap enabled by option" "$actual_enabled_wrap" = '--preview-window "wrap"'
set -e fzfish_wrap_default_preview

set -e fzfish_commandline
set -gx _fzfish_unordered_comp $curr_fzfish_unordered_comp
set -gx _fzfish_ordered_comp $curr_fzfish_ordered_comp
command $fzfish_rm_cmd $_fzfish_complist_path
