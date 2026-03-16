set curr_fzfish_unordered_comp $_fzfish_unordered_comp
set dir "tests/_resources/dir with spaces"
set _fzfish_complist_path (mktemp)

function _fzfish_test_exposed_vars
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
    '.*' \
    _fzfish_test_exposed_vars \
    open_cmd \
    source_cmd \
    --fzf_option \
    '.*/(.*\.txt)$'

set _fzfish_unordered_comp comp_1

set var candidate
set actual (_fzfish_action "preview" "$dir/file 1.txt")
@test "exposed vars fzfish_candidate" "$actual" = "$dir/file 1.txt"

set var extracted
set -x fzfish_extracted
set _fzfish_extract_regex '.*/(.*\.txt)$'
set actual (_fzfish_action "preview" "$dir/file 1.txt")
@test "exposed vars fzfish_extracted" "$actual" = "file 1.txt"

set var query
set -x fzfish_query
set actual (_fzfish_action "preview" "$dir/file 1.txt" "1")
@test "exposed vars fzfish_query" "$actual" = 1

command $fzfish_rm_cmd $_fzfish_complist_path
