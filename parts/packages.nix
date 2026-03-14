{self, ...}: {
  perSystem = {pkgs, ...}: let
    fifc = pkgs.fishPlugins.buildFishPlugin {
      pname = "fifc";
      version = "unstable-${self.lastModifiedDate or "dirty"}";
      src = self;

      meta = {
        description = "Fzf-powered fish completions with customizable completion rules";
        homepage = "https://github.com/adam01110/fifc";
        license = pkgs.lib.licenses.mit;
      };
    };
  in {
    packages = {
      inherit fifc;
      default = fifc;
    };
  };
}
