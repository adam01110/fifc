set curr_fzfish_unordered_comp $_fzfish_unordered_comp
set curr_fzfish_ordered_comp $_fzfish_ordered_comp
set dir "tests/_resources/dir with spaces"
set _fzfish_complist_path (mktemp)

function seq
    echo 0
end

echo "fallback    description" >$_fzfish_complist_path
set _fzfish_unordered_comp
set _fzfish_ordered_comp
set actual (_fzfish_action "preview" 'fallback')
@test "preview fallback ignores empty completion list on seq zero" "$actual" = description

functions -e seq

# Add unordered completions
set comp_1 \
    'test -f $fzfish_candidate' \
    '^cat $' \
    'echo comp_1' \
    open_cmd \
    source_cmd \
    --fzf_option \
    extract_regex

set comp_2 \
    'test -d $fzfish_candidate' \
    '^ls $' \
    'echo comp_2' \
    open_cmd \
    source_cmd \
    --fzf_option \
    extract_regex

set _fzfish_unordered_comp comp_1 comp_2

set fzfish_commandline "cat "
set actual (_fzfish_action "preview" "$dir/file 1.txt")
@test "preview match condition and regex first completion" "$actual" = comp_1

set fzfish_commandline "ls "
set actual (_fzfish_action "preview" "$dir")
@test "preview match condition and regex second completion" "$actual" = comp_2

echo "fallback    description" >$_fzfish_complist_path
set fzfish_commandline "fallback "
set actual (_fzfish_action "preview" 'fallback')
@test "preview fallback fish description" "$actual" = description

# Add ordered completion, should be evaluated before unordered ones
set o_comp_1 \
    'test -f $fzfish_candidate' \
    '^cat $' \
    'echo o_comp_1' \
    open_cmd \
    source_cmd_1 \
    --fzf_option_1 \
    extract_regex_1

set _fzfish_ordered_comp o_comp_1
set fzfish_commandline "cat "
set actual (_fzfish_action "preview" "$dir/file 1.txt")
@test "preview match condition and regex ordered completion" "$actual" = o_comp_1

set -e fzfish_commandline
set -gx _fzfish_unordered_comp $curr_fzfish_unordered_comp
set -gx _fzfish_ordered_comp $curr_fzfish_ordered_comp
command $fzfish_rm_cmd $_fzfish_complist_path
