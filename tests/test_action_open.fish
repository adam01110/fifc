set curr_fzfish_unordered_comp $_fzfish_unordered_comp
set curr_fzfish_ordered_comp $_fzfish_ordered_comp
set dir "tests/_resources/dir with spaces"
set _fzfish_complist_path (mktemp)

function _fzfish_test_open_action
    switch $var
        case candidate
            echo -n "$fzfish_candidate"
        case extracted
            echo -n "$fzfish_extracted"
        case query
            echo -n "$fzfish_query"
    end
end

set comp_1 \
    'test -f $fzfish_candidate' \
    '^cat $' \
    preview_cmd \
    _fzfish_test_open_action \
    source_cmd \
    --fzf_option \
    '.*/(.*\.txt)$'

set _fzfish_unordered_comp comp_1
set fzfish_commandline "cat "

set var candidate
set actual (_fzfish_action open "$dir/file 1.txt" needle)
@test "open action exposes candidate" "$actual" = "$dir/file 1.txt"

set var extracted
set actual (_fzfish_action open "$dir/file 1.txt" needle)
@test "open action exposes extracted match" "$actual" = 'file 1.txt'

set var query
set actual (_fzfish_action open "$dir/file 1.txt" needle)
@test "open action exposes query" "$actual" = needle

functions -e _fzfish_test_open_action
set -e fzfish_commandline
set -gx _fzfish_unordered_comp $curr_fzfish_unordered_comp
set -gx _fzfish_ordered_comp $curr_fzfish_ordered_comp
command $fzfish_rm_cmd $_fzfish_complist_path
