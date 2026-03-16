set -g _mock_buffer 'cd ~/foo'
set -g _mock_current_token '~/foo'
set -g _mock_tmpfile "$PWD/tests/_tmp_main_command_directory_completion"
set -g _mock_complist_path "$_mock_tmpfile"_fzfish
set -g _mock_home "$PWD/tests/_tmp_main_command_directory_completion_home"
set -g _mock_old_home "$HOME"

mkdir -p "$_mock_home/foo"
set -gx HOME "$_mock_home"

function mktemp
    echo $_mock_tmpfile
end

function complete
    printf '%s\n' '~/foo\tfoo desc'
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
            true
    end
end

function _fzfish_completion_group
    echo directories
end

function _fzfish_action
    if test "$argv[1]" = source
        echo "printf '%s\\n' '~/foo'"
    end
end

function fzf
    cat >/dev/null
    printf '%s\n' '~/foo'
end

set -gx fzfish_open_keybinding ctrl-o
set -gx fzfish_rm_cmd rm -f

rm -f $_mock_complist_path
set -e _mock_replaced

_fzfish

@test "main command does not append space to tilde directories" "$_mock_replaced" = '~/foo'

functions -e mktemp
functions -e complete
functions -e commandline
functions -e _fzfish_completion_group
functions -e _fzfish_action
functions -e fzf

set -e _mock_buffer
set -e _mock_current_token
set -e _mock_tmpfile
set -e _mock_complist_path
set -e _mock_replaced
set -e fzfish_open_keybinding
set -e fzfish_rm_cmd
set -gx HOME "$_mock_old_home"
set -e _mock_old_home

rmdir "$_mock_home/foo"
rmdir "$_mock_home"
rm -f "$PWD/tests/_tmp_main_command_directory_completion_fzfish"
set -e _mock_home
