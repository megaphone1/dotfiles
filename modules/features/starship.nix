{
  flake.homeModules.starship = {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        add_newline = false;
      };
    };

    programs.fish.enable = true;
    stylix.targets.starship.enable = true;
  };
}
