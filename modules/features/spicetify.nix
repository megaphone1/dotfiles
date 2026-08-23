{ inputs, ... }:
{
  flake.homeModules.spicetify = { ... }: {
    imports = [
      inputs.spicetify.homeManagerModules.default
    ];

    programs.spicetify = {
      enable = true;
      wayland = true;
      experimentalFeatures = true;
    };
  };
}
