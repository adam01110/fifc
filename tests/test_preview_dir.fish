function type
    if test "$argv[1]" = -q
        switch "$argv[2]"
            case eza exa ls
                test "$argv[2]" = "$preview_dir_bin"
                return $status
        end
    end

    builtin type $argv
end

function eza
    echo "eza:$argv"
end

function exa
    echo "exa:$argv"
end

function ls
    echo "ls:$argv"
end

set fifc_candidate tests/_resources

set preview_dir_bin eza
set actual (_fifc_preview_dir)
@test "directory preview prefers eza" "$actual" = "eza:-1a --color=always tests/_resources"

set preview_dir_bin exa
set actual (_fifc_preview_dir)
@test "directory preview falls back to exa" "$actual" = "exa:-1a --color=always tests/_resources"

set preview_dir_bin ls
set actual (_fifc_preview_dir)
@test "directory preview falls back to ls" "$actual" = "ls:-A -F tests/_resources"

set fzf_preview_dir_cmd 'echo custom:$argv'
set actual (_fifc_preview_dir)
@test "directory preview allows custom command override" "$actual" = "custom: tests/_resources"

functions -e type
functions -e eza
functions -e exa
functions -e ls
set -e fzf_preview_dir_cmd
set -e preview_dir_bin
