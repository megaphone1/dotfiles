{
  flake.homeModules.xdg = { pkgs, ... }: {
    xdg = {
      enable = true;
      portal = {
        enable = true;
      };
    };
  };
}
