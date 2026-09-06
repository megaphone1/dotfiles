{inputs, ...}: {
  flake.nixosModules.yazi = {...}: {
    nixpkgs.overlays = [
      inputs.yazi.overlays.default
    ];
  };

  flake.homeModules.yazi = {pkgs, ...}: {
    programs.yazi = {
      enable = true;
      package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;
      enableFishIntegration = true;
      settings = {
        log = {
          enabled = false;
        };

        mgr = {
          show_hidden = true;
        };
      };
    };
  };
}
