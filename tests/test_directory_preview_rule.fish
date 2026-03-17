set -gx _fzfish_comp_count 0
set -gx _fzfish_unordered_comp
set -gx _fzfish_ordered_comp
set -gx _fzfish_launched_by_fzf 1

source conf.d/fzfish.fish

function _fzfish_preview_dir
    echo dir-preview
end

set -gx _fzfish_complist_path (mktemp)
printf 'tests/_resources\n' >$_fzfish_complist_path
set -gx fzfish_commandline 'cd '
set -gx fzfish_candidate tests/_resources
set -gx fzfish_group directories
set -gx fzfish_desc
set -gx _fzfish_extract_regex

set actual (_fzfish_action preview tests/_resources)
@test "directories use directory preview rule" "$actual" = dir-preview

functions -e _fzfish_preview_dir
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
