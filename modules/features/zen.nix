{ inputs, ... }: {
  flake.homeModules.zen =
    { pkgs, ... }:
    let
      zen-addons = inputs.zen-addons.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [
        inputs.zen.homeModules.beta
      ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;

        policies = {
          DisableAppUpdate = true;
          DisableTelemetry = true;
          DisablePocket = true;
        };

        profiles.default = {
          extensions = {
            packages = with zen-addons; [
              ublock-origin
              darkreader
              vimium
            ];
          };
        };
      };

      stylix.targets.zen-browser.profileNames = [ "default" ];
    };
}
