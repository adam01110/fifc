functions -c _fzfish_source_files _fzfish_source_files_original

function _fzfish_source_files
    printf '%s\n' "$fzfish_fd_opts"
    printf '%s\n' --
    printf '%s\n' "$fzfish_find_opts"
end

set -e fzfish_fd_opts
set -e fzfish_find_opts
set actual (_fzfish_source_directories | string join '|')
@test "directory source adds fd type filter" "$actual" = "-t d|--|"

set -gx fzfish_fd_opts --hidden
set actual (_fzfish_source_directories | string join '|')
@test "directory source preserves existing fd opts" "$actual" = "--hidden -t d|--|"

function type
    if test "$argv[1]" = -q; and test "$argv[2]" = fd
        return 1
    end

    builtin type $argv
end

set -e fzfish_fd_opts
set -e fzfish_find_opts
set actual (_fzfish_source_directories | string join '|')
@test "directory source adds find type filter" "$actual" = "|--|-type d"

set -gx fzfish_find_opts -maxdepth 2
set actual (_fzfish_source_directories | string join '|')
@test "directory source preserves existing find opts" "$actual" = "|--|-maxdepth 2 -type d"

functions -e type
functions -e _fzfish_source_files
functions -c _fzfish_source_files_original _fzfish_source_files
functions -e _fzfish_source_files_original

set -e fzfish_fd_opts
set -e fzfish_find_opts
