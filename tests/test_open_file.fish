set dir "tests/_resources/dir with spaces"
set curr_fzfish_editor $fzfish_editor
set fzfish_editor cat
set fzfish_candidate "$dir/file 1.txt"

set actual (_fzfish_open_file)
@test "builtin file open" "$actual" = 'foo 1'

set fzfish_editor $curr_fzfish_editor
