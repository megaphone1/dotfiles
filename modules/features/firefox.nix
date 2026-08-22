{ inputs, ... }:
{
  flake.homeModules.firefox =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            id = 0;
            name = "default";
            isDefault = true;

            extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
              ublock-origin
              darkreader
              vimium
            ];

            settings = {
              "widget-use-xdg-desktop-portal.file-picker" = 1;
              "widget.use-wayland-xdg-app.enabled" = true;

              "extensions.autoDisableScopes" = 0;
              "extensions.pocket.enabled" = false;
            };
          };
        };
      };
    };
}
