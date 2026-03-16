function _fzfish_timg_pixelation -d "Choose the timg pixelation mode"
    if set -q fzfish_timg_pixelation
        set -l requested_mode (string lower -- "$fzfish_timg_pixelation[1]")

        switch $requested_mode
            case kitty k
                echo -pk
                return 0
            case iterm2 iterm i
                echo -pi
                return 0
            case sixel s
                echo -ps
                return 0
            case half h
                echo -ph
                return 0
            case quarter q
                echo -pq
                return 0
        end
    end

    if set -q KITTY_WINDOW_ID
        or begin
            set -q TERM
            and string match -qr '(^|-)kitty$' -- "$TERM"
        end
        or begin
            set -q TERM_PROGRAM
            and contains -- "$TERM_PROGRAM" ghostty WezTerm
        end
        or set -q WEZTERM_EXECUTABLE
        or set -q KONSOLE_VERSION
        echo -pk
    end
end
