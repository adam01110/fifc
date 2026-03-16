function _fzfish_preview_fn -d "Preview the function definition"
    if type -q bat
        type $fzfish_candidate | bat --color=always --language fish $fzfish_bat_opts
    else
        type $fzfish_candidate
    end
end
