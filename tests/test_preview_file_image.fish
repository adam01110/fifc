set dir "tests/_resources/dir with spaces"
set fzfish_candidate "$dir/fish.png"
set -gx KITTY_WINDOW_ID 1
set -gx FZF_PREVIEW_COLUMNS 37
set -gx FZF_PREVIEW_LINES 11
set -gx fzfish_timg_opts --center

function timg
    printf '%s\n' $argv
end

set actual (_fzfish_preview_file)
set rendered (string join -- ' ' $actual)

@test "image preview uses timg" (string match -- "*-pk*--frames=1*--loops=1*-E*-g37x22*--center*$dir/fish.png*" "$rendered") = "$rendered"

functions -e timg
set -e KITTY_WINDOW_ID
set -e FZF_PREVIEW_COLUMNS
set -e FZF_PREVIEW_LINES
set -e fzfish_timg_opts
