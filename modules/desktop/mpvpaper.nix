{ ... }:
{
  flake.homeModules.mpvpaper =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = [ pkgs.mpv ];

      programs.mpvpaper = {
        enable = true;
        package = pkgs.mpvpaper;
        stopList = ''
          steam
        '';
        pauseList = ''
          firefox
        '';
      };
    };
}
