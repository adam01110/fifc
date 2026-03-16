set -gx fzfish_timg_pixelation sixel
@test "timg pixelation honors explicit sixel override" (_fzfish_timg_pixelation) = -ps
set -e fzfish_timg_pixelation

set -gx fzfish_timg_pixelation kitty
@test "timg pixelation honors explicit kitty override" (_fzfish_timg_pixelation) = -pk
set -e fzfish_timg_pixelation

set -gx KITTY_WINDOW_ID 1
@test "timg pixelation detects kitty protocol support" (_fzfish_timg_pixelation) = -pk
set -e KITTY_WINDOW_ID
