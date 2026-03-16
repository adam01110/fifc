function _fzfish_open_file -d "Open a file with the right tool depending on its type"
    set -l filepath "$fzfish_candidate"

    if test -n "$argv"
        set filepath "$argv"
    end

    set -q fzfish_editor || set -l fzfish_editor "$EDITOR"

    set -l file_type (_fzfish_file_type "$filepath")

    switch $file_type
        case txt json archive
            $fzfish_editor "$filepath"
        case image pdf
            if type -q timg
                set -l pixelation (_fzfish_timg_pixelation)

                timg $pixelation --frames=1 --loops=1 --clear -E $fzfish_timg_opts "$filepath" | less --RAW-CONTROL-CHARS
            else
                $fzfish_editor "$filepath"
            end
        case binary
            if type -q hexyl
                hexyl $fzfish_hexyl_opts "$filepath" | less --RAW-CONTROL-CHARS
            else
                $fzfish_editor "$filepath"
            end
    end
end
