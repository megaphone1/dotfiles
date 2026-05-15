{inputs, ...}: {
  flake.homeModules.ghostty = {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  flake.nixosModules.ghostty = {pkgs, ...}: {
    nixpkgs.overlays = [
      inputs.ghostty.overlays.default
    ];

    environment.systemPackages = with pkgs; [
      ghostty
    ];
  };
}
