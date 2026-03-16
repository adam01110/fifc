function _fzfish_preview_dir -d "List content of the selected directory"
    if set --query fzf_preview_dir_cmd
        eval "$fzf_preview_dir_cmd '$fzfish_candidate'"
    else if type -q eza
        eza -1a --color=always $fzfish_exa_opts "$fzfish_candidate"
    else if type -q exa
        exa -1a --color=always $fzfish_exa_opts "$fzfish_candidate"
    else
        ls -A -F $fzfish_ls_opts "$fzfish_candidate"
    end
end
