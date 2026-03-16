set _fzfish_complist_path (mktemp)

set _commandline "kill "
complete -C --escape -- "$_commandline" >$_fzfish_complist_path
set fzfish_commandline "$_commandline"
set actual (_fzfish_completion_group)
@test "group test pid" "$actual" = processes

set _commandline "ls tests/_resources/dir\ with\ spaces/"
complete -C --escape -- "$_commandline" >$_fzfish_complist_path
set fzfish_commandline "$_commandline"
set actual (_fzfish_completion_group)
@test "group test files" "$actual" = files

set _commandline "cd tests/_resources/"
complete -C --escape -- "$_commandline" >$_fzfish_complist_path
set fzfish_commandline "$_commandline"
set actual (_fzfish_completion_group)
@test "group test directories" "$actual" = directories

set _commandline "ls -"
complete -C --escape -- "$_commandline" >$_fzfish_complist_path
set fzfish_commandline "$_commandline"
set actual (_fzfish_completion_group)
@test "group test options" "$actual" = options

set -e _fzfish_complist
set -e fzfish_commandline
command $fzfish_rm_cmd $_fzfish_complist_path
