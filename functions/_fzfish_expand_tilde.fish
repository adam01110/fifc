function _fzfish_expand_tilde
    string replace --regex -- '^~' "$HOME" $argv
end
