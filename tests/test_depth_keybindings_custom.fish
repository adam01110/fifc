set -gx _fzfish_comp_count 0
set -gx _fzfish_unordered_comp
set -gx _fzfish_ordered_comp

set -gx fzfish_depth_increase_keybindings alt-n alt-right
set -gx fzfish_depth_decrease_keybindings alt-p alt-left
set -gx fzfish_depth_direct_keybindings alt-7 alt-8

source conf.d/fzfish.fish

_fzfish_set_bindings

set actual_dir_opts "$_fzfish_comp_1[6]"
string match --quiet -- "*alt-n:transform(_fzfish_depth_transform +1 d)*" "$actual_dir_opts"
set actual_status $status
@test "custom directory increase depth keybinding" "$actual_status" = 0

string match --quiet -- "*alt-p:transform(_fzfish_depth_transform -1 d)*" "$actual_dir_opts"
set actual_status $status
@test "custom directory decrease depth keybinding" "$actual_status" = 0

string match --quiet -- "*alt-7:transform(_fzfish_depth_transform 1 d)*" "$actual_dir_opts"
set actual_status $status
@test "custom directory direct depth first keybinding" "$actual_status" = 0

string match --quiet -- "*alt-8:transform(_fzfish_depth_transform 2 d)*" "$actual_dir_opts"
set actual_status $status
@test "custom directory direct depth second keybinding" "$actual_status" = 0

string match --quiet -- "*set:alt-7/alt-8*" "$actual_dir_opts"
set actual_status $status
@test "custom directory header reflects direct depth keybindings" "$actual_status" = 0

set -e fzfish_depth_increase_keybindings
set -e fzfish_depth_decrease_keybindings
set -e fzfish_depth_direct_keybindings
set -e _fzfish_comp_count
set -e _fzfish_unordered_comp
set -e _fzfish_ordered_comp
