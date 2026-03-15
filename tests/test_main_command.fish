set -g _mock_buffer 'git foo'
set -g _mock_current_token foo
set -g _mock_group files
set -g _mock_tmpfile "$PWD/tests/_tmp_main_command"
set -g _mock_complist_path "$_mock_tmpfile"_fifc

function mktemp
    echo $_mock_tmpfile
end

function complete
    printf '%s\n' 'alpha	alpha desc'
end

function commandline
    switch "$argv[1]"
        case --current-token
            echo $_mock_current_token
        case --cut-at-cursor -b
            echo $_mock_buffer
        case --replace
            set -g _mock_replaced $argv[-1]
        case --function
            set -g _mock_commandline_function $argv[2]
    end
end

function _fifc_completion_group
    echo $_mock_group
end

function _fifc_action
    if test "$argv[1]" = source
        echo "printf '%s\\n' alpha"
    end
end

function fzf
    set -g _mock_fzf_args $argv
    cat >/dev/null
    printf '%s\n' alpha
end

set -gx fifc_open_keybinding ctrl-o
set -gx fifc_custom_fzf_opts --layout=default --cycle
set -gx fifc_case_insensitive true
set -gx fifc_rm_cmd false

rm -f $_mock_complist_path
set -e _mock_fzf_args
set -e _mock_replaced
set -e _mock_commandline_function

_fifc

set actual_fzf_cmd (string join -- ' ' $_mock_fzf_args)
set actual_case_flag (string match -- '* -i *' " $actual_fzf_cmd ")
set temp_exists no
if test -f $_mock_complist_path
    set temp_exists yes
end
@test "main command enables case-insensitive matching" "$actual_case_flag" = " $actual_fzf_cmd "
@test "main command stores per-group history" (string match -- "*--history=$HOME/.local/share/fifc/fzf-history-files*" "$actual_fzf_cmd") = "$actual_fzf_cmd"
@test "main command forwards custom fzf opts" (string match -- '*--layout=default --cycle*' "$actual_fzf_cmd") = "$actual_fzf_cmd"
@test "main command binds tab navigation inside fzf" (string match -- "*--bind=tab:down,shift-tab:up*" "$actual_fzf_cmd") = "$actual_fzf_cmd"
@test "main command replaces current token with trailing space" "$_mock_replaced" = 'alpha '
@test "main command repaints commandline" "$_mock_commandline_function" = repaint
@test "main command uses configured temp file remover" "$temp_exists" = yes

set -g _mock_group ''
set -e _mock_fzf_args
rm -f $_mock_complist_path

_fifc

set actual_fzf_cmd (string join -- ' ' $_mock_fzf_args)
@test "main command falls back to default history group" (string match -- "*--history=$HOME/.local/share/fifc/fzf-history-default*" "$actual_fzf_cmd") = "$actual_fzf_cmd"

functions -e mktemp
functions -e complete
functions -e commandline
functions -e _fifc_completion_group
functions -e _fifc_action
functions -e fzf

set -e _mock_buffer
set -e _mock_current_token
set -e _mock_group
set -e _mock_tmpfile
set -e _mock_complist_path
set -e _mock_fzf_args
set -e _mock_replaced
set -e _mock_commandline_function
set -e actual_case_flag
set -e temp_exists
set -e fifc_open_keybinding
set -e fifc_custom_fzf_opts
set -e fifc_case_insensitive
set -e fifc_rm_cmd

rm -f "$PWD/tests/_tmp_main_command_fifc"
