{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.hyprland =
    {
      pkgs,
      config,
      ...
    }:
    {
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };

      hardware.graphics = {
        package = pkgs.mesa;
      };

      services.seatd = {
        enable = true;
      };

      users.users.${config.user.name} = {
        extraGroups = [
          "video"
          "seat"
        ];
      };

      security.polkit.enable = true;

      environment.sessionVariables = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      environment.systemPackages = with pkgs; [
        wl-clipboard
        cliphist
      ];

      services.getty.autologinUser = "${config.user.name}";
      environment.loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          exec start-hyprland
        fi
      '';
    };

  flake.homeModules.hyprland = { pkgs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      configType = "lua";
      extraConfig = ''
        ${builtins.readFile (self + "/config/hypr/cleanup.lua")}
        ${builtins.readFile (self + "/config/hypr/monitors.lua")}
        ${builtins.readFile (self + "/config/hypr/programs.lua")}
        ${builtins.readFile (self + "/config/hypr/autostart.lua")}
        ${builtins.readFile (self + "/config/hypr/environment.lua")}
        ${builtins.readFile (self + "/config/hypr/layout.lua")}
        ${builtins.readFile (self + "/config/hypr/layers.lua")}
        ${builtins.readFile (self + "/config/hypr/input.lua")}
        ${builtins.readFile (self + "/config/hypr/keybinds.lua")}
        ${builtins.readFile (self + "/config/hypr/workspaces.lua")}
      '';
    };
  };
}
