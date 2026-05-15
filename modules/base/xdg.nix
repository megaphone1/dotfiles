{
  flake.homeModules.xdg = {
    xdg = {
      enable = true;

      portal = {
        enable = true;
      };
    };

    home.sessionVariables = {
      XDG_DESKTOP_DIR = "$HOME/";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };
  };
}
