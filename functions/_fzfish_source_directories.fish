function _fzfish_source_directories -d "Return a command to recursively find directories"
    if type -q fd
        set --local --export --append fzfish_fd_opts -t d
        _fzfish_source_files
    else
        set --local --export --append fzfish_find_opts -type d
        _fzfish_source_files
    end
end
