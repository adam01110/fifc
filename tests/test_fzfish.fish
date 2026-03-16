set curr_fzfish_unordered_comp $_fzfish_unordered_comp
set _fzfish_unordered_comp

fzfish \
    -n 'test -n "$fzfish_desc"' \
    -r '^functions\h+|^\h+' \
    -p _fzfish_preview_fn \
    -o _fzfish_open_fn

@test "fzfish command completion added" (count $_fzfish_unordered_comp) = 1
@test "fzfish command completion condition" "$$_fzfish_unordered_comp[1][1]" = 'test -n "$fzfish_desc"'
@test "fzfish command completion regex" "$$_fzfish_unordered_comp[1][2]" = '^functions\h+|^\h+'
@test "fzfish command completion preview" "$$_fzfish_unordered_comp[1][3]" = _fzfish_preview_fn
@test "fzfish command completion open" "$$_fzfish_unordered_comp[1][4]" = _fzfish_open_fn

# set _fzfish_unordered_comp
fzfish \
    -n 'test -n "$fzfish_desc"' \
    -r '^functions\h+|^\h+' \
    -s source_cmd

@test "fzfish source added" (count $_fzfish_unordered_comp) = 2
@test "fzfish source condition" "$$_fzfish_unordered_comp[2][1]" = 'test -n "$fzfish_desc"'
@test "fzfish source regex" "$$_fzfish_unordered_comp[2][2]" = '^functions\h+|^\h+'
@test "fzfish source command" "$$_fzfish_unordered_comp[2][5]" = source_cmd

set -gx _fzfish_unordered_comp $curr_fzfish_unordered_comp
