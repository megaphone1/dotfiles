{ ... }: {
  flake.homeModules.alacritty = {
    programs.alacritty = {
      enable = true;
    };
  };
}
