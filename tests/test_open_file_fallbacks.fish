set curr_fzfish_editor $fzfish_editor
set fzfish_editor cat
set fzfish_candidate tests/_resources/target.txt

function _fzfish_file_type
    echo $mock_file_type
end

set mock_file_type image
set actual_image (_fzfish_open_file "tests/_resources/dir with spaces/file 1.txt")
@test "open file falls back to editor when image viewer is unavailable" "$actual_image" = 'foo 1'

set mock_file_type binary
set actual_binary (_fzfish_open_file "tests/_resources/dir with spaces/file 1.txt")
@test "open file falls back to editor when hex viewer is unavailable" "$actual_binary" = 'foo 1'

set mock_file_type txt
set actual_arg (_fzfish_open_file "tests/_resources/dir with spaces/file 2.txt")
@test "open file uses explicit argument over candidate" "$actual_arg" = 'foo 2'

functions -e _fzfish_file_type
set fzfish_editor $curr_fzfish_editor
set -e fzfish_candidate
set -e mock_file_type
