set -gx _fzfish_comp_count 0
set -gx _fzfish_unordered_comp
set -gx _fzfish_ordered_comp
set -gx _fzfish_launched_by_fzf 1

source conf.d/fzfish.fish

function _fzfish_preview_process
    echo process-preview
end

set -gx _fzfish_complist_path (mktemp)
printf 'fish\n' >$_fzfish_complist_path

set -gx fzfish_commandline 'pkill '
set -gx fzfish_candidate fish
set -gx fzfish_group
set -gx fzfish_desc
set -gx _fzfish_extract_regex

function pgrep
    echo 101
end

set actual (_fzfish_action preview fish)
@test "pkill uses process preview rule" "$actual" = process-preview

functions -e _fzfish_preview_process
functions -e pgrep
rm -f $_fzfish_complist_path
set -e _fzfish_comp_count
set -e _fzfish_unordered_comp
set -e _fzfish_ordered_comp
set -e _fzfish_launched_by_fzf
set -e _fzfish_complist_path
set -e fzfish_commandline
set -e fzfish_candidate
set -e fzfish_group
set -e fzfish_desc
set -e _fzfish_extract_regex
