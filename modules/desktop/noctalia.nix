{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.noctalia =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };

  flake.homeModules.noctalia =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      wallpaperUrl = "https://github.com/orangci/walls-catppuccin-mocha";
      wallpaperDir = "/home/${config.user.name}/.local/share/walls-catppuccin-mocha";
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      home.activation = {
        cloneWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ -d "${wallpaperDir}" ]; then
             (cd "${wallpaperDir}" && ${pkgs.git}/bin/git pull)
          else
             ${pkgs.git}/bin/git clone --depth=1 "${wallpaperUrl}" "${wallpaperDir}"
          fi
        '';
      };

      programs.noctalia= {
        enable = true;

        settings = {
          dock = {
            colorizeIcons = true;
            launcherIcon = "";
            launcherUseDistroLogo = true;
          };

          general = {
            avatarImage = "${self}/config/avatar.jpg";
          };

          location = {
            name = config.user.location;
          };

          wallpaper = {
            enabled = true;
            directory = wallpaperDir;
          };
        };
      };
    };
}
