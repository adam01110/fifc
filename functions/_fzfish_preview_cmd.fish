function _fzfish_preview_cmd -d "Open man page of the selected command"
    if type -q bat
        man $fzfish_candidate 2>/dev/null | bat --color=always --language man $fzfish_bat_opts
    else
        man $fzfish_candidate 2>/dev/null
    end
end
