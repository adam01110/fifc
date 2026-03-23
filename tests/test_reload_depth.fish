set -gx fzfish_token tests/_resources/
set -gx fzfish_query tests/_resources/

set actual (_fzfish_reload_depth 1 d | string replace --regex --all '\e\[[0-9;]*m' '' | string join '|')
set match (string match -- "*tests/_resources/dir with spaces*" "$actual")
@test "reload depth fd mode lists directories" "$match" = "$actual"
set match (string match -- "*target.txt*" "$actual")
@test "reload depth fd mode excludes files in directory mode" "$match" = ""
@test "reload depth fd mode preserves query" "$fzfish_query" = tests/_resources/

function type
    if test "$argv[1]" = -q; and test "$argv[2]" = fd
        return 1
    end

    builtin type $argv
end

set actual (_fzfish_reload_depth 1 d | string replace --regex --all '\e\[[0-9;]*m' '' | string join '|')
set match (string match -- "*tests/_resources/dir with spaces*" "$actual")
@test "reload depth find mode lists directories" "$match" = "$actual"
set match (string match -- "*target.txt*" "$actual")
@test "reload depth find mode excludes files in directory mode" "$match" = ""
@test "reload depth find mode preserves query" "$fzfish_query" = tests/_resources/

functions -e type

set -gx fzfish_token tests/_resources
set -e _fzfish_complist_path
_fzfish_reload_depth 1 >/dev/null
set actual_status $status
@test "reload depth plain completion without complist path succeeds" "$actual_status" = 0

set -e fzfish_token
set -e fzfish_query
