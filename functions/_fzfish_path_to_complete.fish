function _fzfish_path_to_complete
    set -l token (string unescape -- $fzfish_token)
    if string match --regex --quiet -- '.*(\w|\.|/)+$' "$token"
        _fzfish_expand_tilde "$token"
    else
        echo {$PWD}/
    end
end
