set fzfish_candidate mkdir
set fzfish_bat_opts '--color=never'

set actual (_fzfish_open_cmd)
set expected (man mkdir)
@test "builtin cmd open" "$actual" = "$expected"
