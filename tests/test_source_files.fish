set -gx fzfish_token tests/_resources
set actual (_fzfish_source_files)
@test "source files incomplete path falls back to fish completions" "$actual" = _fzfish_parse_complist

set -gx fzfish_token tests/_resources/
set -gx fzfish_query tests/_resources/
set actual (_fzfish_source_files)
set match (string match -- "fd . *--max-depth 1*" "$actual")
@test "source files fd command limits depth" "$match" = "$actual"
set match (string match -- "*--no-ignore*" "$actual")
@test "source files fd command includes no-ignore" "$match" = "$actual"
@test "source files directory path clears query" "$fzfish_query" = ""

set -gx fzfish_show_hidden true
set actual (_fzfish_source_files)
set match (string match -- "*--hidden*" "$actual")
@test "source files fd command shows hidden when enabled" "$match" = "$actual"
set -e fzfish_show_hidden

set -gx fzfish_query tests/_resources/
set actual (_fzfish_source_files 3 d false)
set match (string match -- "* -t d *--max-depth 3*" "$actual")
@test "source files fd command forwards depth and directory type" "$match" = "$actual"
@test "source files fd command can preserve query on reload" "$fzfish_query" = tests/_resources/

set -gx fzfish_token .hidden/
set actual (_fzfish_source_files)
set match (string match -- "*--hidden*" "$actual")
@test "source files fd command shows hidden for hidden path" "$match" = "$actual"

set -gx fzfish_token "$PWD/"
set -gx fzfish_query "$PWD/"
set actual (_fzfish_source_files)
set match (string match -- "* -- *" "$actual")
@test "source files pwd directory omits explicit path argument" "$match" = ""

function type
    if test "$argv[1]" = -q; and test "$argv[2]" = fd
        return 1
    end

    builtin type $argv
end

set -gx fzfish_token tests/_resources/
set -gx fzfish_query tests/_resources/
set -e fzfish_find_opts
set actual (_fzfish_source_files)
set match (string match -- "*! -path '*/.*'*" "$actual")
@test "source files find fallback excludes hidden by default" "$match" = "$actual"
@test "source files find fallback clears query" "$fzfish_query" = ""

set -gx fzfish_show_hidden true
set actual (_fzfish_source_files)
set match (string match -- "*! -path '*/.*'*" "$actual")
@test "source files find fallback includes hidden when enabled" "$match" = ""
set match (string match -- "*! -path .* -print*" "$actual")
@test "source files find fallback still prints matches" "$match" = "$actual"

set -e fzfish_show_hidden
set -gx fzfish_query tests/_resources/
set actual (_fzfish_source_files 4 d false)
set match (string match -- "* -maxdepth 4 * -type d *" "$actual")
@test "source files find fallback forwards depth and directory type" "$match" = "$actual"
@test "source files find fallback can preserve query on reload" "$fzfish_query" = tests/_resources/

set -gx fzfish_token .hidden/
set actual (_fzfish_source_files)
set match (string match -- "*! -path '*/.*'*" "$actual")
@test "source files find fallback shows hidden for hidden path" "$match" = ""

functions -e type
set -e fzfish_token
set -e fzfish_query
set -e fzfish_show_hidden
set -e fzfish_find_opts
