function _fifc_open_opt -d "Open a man page starting at the selected option"
    set -l cmd (string match --regex --groups-only -- '(^|\h+)(\w+) ?-*$' "$fifc_commandline")
    set -l opt (string trim --chars '\n ' -- "$fifc_candidate")
    set -l regex "^[[:blank:]]*(-+.*)*$opt"

    set -l output (man $cmd | col -b | string collect)

    set -l linenr (echo $output | awk "/$regex/{print NR}")

    if type -q bat
        echo $output | bat --color=always --language man --style plain $fifc_bat_opts \
            # --RAW-CONTROL-CHARS allow color output of bat to be displayed
            | less --RAW-CONTROL-CHARS "+$linenr"
    else
        set -l regex "^[[:blank:]]*(-+.*)*$opt"
        man $cmd | less "+$linenr"
    end
end
