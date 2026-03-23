function _fzfish_parse_pid -d "Extract pids from process candidates"
    set -l candidate $argv[1]
    set -l pids (string match --regex --groups-only -- "^\h*([0-9]+)" "$candidate")

    if test -z "$pids"; and test (count $argv) -ge 2
        if string match --regex --quiet -- '(^|.*\h)pkill(\h|$)' "$argv[2]"
            set pids (pgrep -- "$candidate" 2>/dev/null)
        end
    end

    echo $pids
end
