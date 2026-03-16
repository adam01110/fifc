set dir "tests/_resources/dir with spaces"
set fzfish_candidate "$dir/fish.png"
set -gx KITTY_WINDOW_ID 1
set -gx fzfish_timg_opts --center

function timg
    printf '%s\n' $argv
end

function less
    cat
end

set actual (_fzfish_open_file)
set rendered (string join -- ' ' $actual)

@test "image open uses timg" (string match -- "*-pk*--frames=1*--loops=1*--clear*-E*--center*$dir/fish.png*" "$rendered") = "$rendered"

set actual_pdf (_fzfish_open_file "$dir/file.pdf")
set rendered_pdf (string join -- ' ' $actual_pdf)

@test "pdf open uses timg" (string match -- "*-pk*--frames=1*--loops=1*--clear*-E*--center*$dir/file.pdf*" "$rendered_pdf") = "$rendered_pdf"

functions -e timg
functions -e less
set -e KITTY_WINDOW_ID
set -e fzfish_timg_opts
