_: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (pkgs.lib) attrValues;

    inherit (config.packages) fzfish;
    commonPackages = attrValues {
      inherit fzfish;
      inherit (pkgs) fish fzf man-db;
    };

    mkInteractiveShell = name: packages:
      pkgs.mkShell {
        inherit packages;

        shellHook = ''
          export FZFISH_SHELL_ROOT="$PWD/.nix-fzfish-shell/${name}"
          export HOME="$FZFISH_SHELL_ROOT/home"
          export XDG_CACHE_HOME="$HOME/.cache"
          export XDG_CONFIG_HOME="$HOME/.config"
          export XDG_DATA_HOME="$HOME/.local/share"

          mkdir -p \
            "$XDG_CACHE_HOME" \
            "$XDG_CONFIG_HOME/fish/conf.d" \
            "$XDG_CONFIG_HOME/fish/completions" \
            "$XDG_CONFIG_HOME/fish/functions" \
            "$XDG_DATA_HOME/fish/vendor_conf.d" \
            "$XDG_DATA_HOME/fish/vendor_completions.d" \
            "$XDG_DATA_HOME/fish/vendor_functions.d" \
            "$FZFISH_SHELL_ROOT/sandbox"

          rm -f \
            "$XDG_DATA_HOME/fish/vendor_conf.d"/*.fish \
            "$XDG_DATA_HOME/fish/vendor_completions.d"/*.fish \
            "$XDG_DATA_HOME/fish/vendor_functions.d"/*.fish

          ln -s ${fzfish}/share/fish/vendor_conf.d/*.fish "$XDG_DATA_HOME/fish/vendor_conf.d/"
          ln -s ${fzfish}/share/fish/vendor_completions.d/*.fish "$XDG_DATA_HOME/fish/vendor_completions.d/"
          ln -s ${fzfish}/share/fish/vendor_functions.d/*.fish "$XDG_DATA_HOME/fish/vendor_functions.d/"

          cat > "$XDG_CONFIG_HOME/fish/config.fish" <<EOF
          set -gx fzfish_editor true
          set -gx fzfish_keybinding \\cf
          EOF

          if test -n "$PS1"; then
            echo "fzfish ${name} shell ready"
            echo "sandbox: $FZFISH_SHELL_ROOT/sandbox"
            echo "config:  $XDG_CONFIG_HOME/fish"
            echo "start:   fish"
          fi
        '';
      };
  in {
    devShells = {
      modern = mkInteractiveShell "modern" (commonPackages
        ++ attrValues {
          inherit (pkgs) bat eza fd hexyl procs ripgrep timg;
        });

      fallback = mkInteractiveShell "fallback" (commonPackages
        ++ attrValues {
          inherit (pkgs) coreutils file findutils pcre procps;
        });
    };
  };
}
