set dir "tests/_resources/dir with spaces"
set fzfish_candidate "$dir/file 1.txt"

function _fzfish_file_type
    echo $mock_file_type
end

function _fzfish_preview_file_default
    echo "DEFAULT:$argv[1]"
end

set mock_file_type image
set actual_image (_fzfish_preview_file)
@test "preview file falls back to default preview when image renderer is unavailable" "$actual_image" = "DEFAULT:$dir/file 1.txt"

set mock_file_type archive
set actual_archive (_fzfish_preview_file)
@test "preview file falls back to default preview when archive lister is unavailable" "$actual_archive" = "DEFAULT:$dir/file 1.txt"

set mock_file_type binary
set actual_binary (_fzfish_preview_file)
@test "preview file falls back to default preview when hex viewer is unavailable" "$actual_binary" = "DEFAULT:$dir/file 1.txt"

functions -e _fzfish_file_type
functions -e _fzfish_preview_file_default
set -e fzfish_candidate
set -e mock_file_type
