{ inputs, ... }:
{
  flake.homeModules.spicetify = { ... }: {
    imports = [
      inputs.spicetify.homeManagerModules.default
    ];

    nixpkgs.config.allowUnfree = true;

    programs.spicetify = {
      enable = true;
      wayland = true;
      experimentalFeatures = true;
    };
  };
}
