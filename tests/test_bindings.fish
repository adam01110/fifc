set -q _fzfish_comp_1
or _fzfish_set_bindings

@test "bindings register directory source rule" "$_fzfish_comp_1[1]" = 'test "$fzfish_group" = "directories"'
@test "bindings register file source rule" "$_fzfish_comp_2[1]" = 'test "$fzfish_group" = "files"'
@test "bindings register process source rule" "$_fzfish_comp_3[1]" = 'test "$fzfish_group" = processes'

@test "bindings directory source command" "$_fzfish_comp_1[5]" = _fzfish_source_directories
set actual_dir_opts "$_fzfish_comp_1[6]"
string match --quiet -- "*ctrl-j:transform(_fzfish_depth_transform +1 d)*" "$actual_dir_opts"
set actual_status $status
@test "bindings directory opts include ctrl-j depth" "$actual_status" = 0
string match --quiet -- "*alt-9:transform(_fzfish_depth_transform 9 d)*" "$actual_dir_opts"
set actual_status $status
@test "bindings directory opts include numeric depth" "$actual_status" = 0

@test "bindings file source command" "$_fzfish_comp_2[5]" = _fzfish_source_files
set actual_file_opts "$_fzfish_comp_2[6]"
string match --quiet -- "*ctrl-j:transform(_fzfish_depth_transform +1)*" "$actual_file_opts"
set actual_status $status
@test "bindings file opts include ctrl-j depth" "$actual_status" = 0
string match --quiet -- "*alt-9:transform(_fzfish_depth_transform 9)*" "$actual_file_opts"
set actual_status $status
@test "bindings file opts include numeric depth" "$actual_status" = 0

@test "bindings process source command" "$_fzfish_comp_3[5]" = 'ps -ax -o pid=,command='
