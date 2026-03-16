function _fzfish_parse_complist -d "Extract the first column of fish completion list"
    cat $_fzfish_complist_path \
        | string unescape \
        | uniq \
        | awk -F '\t' '{ print $1 }'
end
