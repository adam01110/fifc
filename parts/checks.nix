{self, ...}: {
  perSystem = {pkgs, ...}: {
    checks = {
      fish-syntax =
        pkgs.runCommand "fish-syntax-check" {
          nativeBuildInputs = [pkgs.fish];
        } ''
          set -eu

          for file in \
            ${self}/conf.d/*.fish \
            ${self}/completions/*.fish \
            ${self}/functions/*.fish \
            ${self}/tests/*.fish
          do
            fish --no-execute "$file"
          done

          touch "$out"
        '';

      tests =
        pkgs.runCommand "fzfish-tests" {
          nativeBuildInputs = with pkgs; [
            bat
            coreutils
            fd
            file
            findutils
            fish
            fishPlugins.fishtape
            fzf
            gnugrep
            gnused
            man-db
            procps
          ];
        } ''
          set -eu

          export HOME="$TMPDIR/home"
          export XDG_CACHE_HOME="$HOME/.cache"
          export XDG_CONFIG_HOME="$HOME/.config"
          export XDG_DATA_HOME="$HOME/.local/share"

          cp -r ${self} source
          chmod -R u+w source

          mkdir -p \
            "$XDG_CACHE_HOME" \
            "$XDG_CONFIG_HOME/fish/completions" \
            "$XDG_CONFIG_HOME/fish/conf.d" \
            "$XDG_CONFIG_HOME/fish/functions" \
            "$XDG_DATA_HOME/fish/vendor_functions.d"

          ln -s "$PWD"/source/conf.d/*.fish "$XDG_CONFIG_HOME/fish/conf.d/"
          ln -s "$PWD"/source/completions/*.fish "$XDG_CONFIG_HOME/fish/completions/"
          ln -s "$PWD"/source/functions/*.fish "$XDG_CONFIG_HOME/fish/functions/"
          ln -s ${pkgs.fishPlugins.fishtape}/share/fish/vendor_functions.d/*.fish "$XDG_DATA_HOME/fish/vendor_functions.d/"

          cd source
          fish -c 'source "$XDG_CONFIG_HOME/fish/conf.d/fzfish.fish"; _fzfish_set_bindings'
          fish -c 'fishtape tests/*.fish'

          touch "$out"
        '';
    };
  };
}
