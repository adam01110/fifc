set dir "tests/_resources/dir with spaces"
set fzfish_candidate "$dir/file 1.txt"
set fzfish_bat_opts '--color=never'

set actual (_fzfish_preview_file)
@test "builtin file preview" "$actual" = 'foo 1'
