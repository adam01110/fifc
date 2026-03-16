{self, ...}: {
  perSystem = {pkgs, ...}: let
    fzfish = pkgs.fishPlugins.buildFishPlugin {
      pname = "fzfish";
      version = "unstable-${self.lastModifiedDate or "dirty"}";
      src = self;

      meta = {
        description = "FzFish: fzf-powered fish completions with customizable completion rules";
        homepage = "https://github.com/adam01110/fzfish";
        license = pkgs.lib.licenses.mit;
      };
    };
  in {
    packages = {
      inherit fzfish;
      default = fzfish;
    };
  };
}
