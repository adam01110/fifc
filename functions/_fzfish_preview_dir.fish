function _fzfish_preview_dir -d "List content of the selected directory"
    set -l filepath "$fzfish_candidate"

    if set --query fzf_preview_dir_cmd
        eval "$fzf_preview_dir_cmd '$filepath'"
        return
    end

    for dir_cmd in eza exa
        if type -q $dir_cmd
            set -l dir_opts
            switch $dir_cmd
                case eza
                    set dir_opts $fzfish_eza_opts
                case exa
                    set dir_opts $fzfish_exa_opts
            end

            $dir_cmd -1a --color=always $dir_opts "$filepath"
            return
        end
    end

    ls -A -F $fzfish_ls_opts "$filepath"
end
