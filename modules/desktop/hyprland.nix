{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {
    pkgs,
    config,
    ...
  }: {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    hardware.graphics = {
      package = pkgs.mesa;
    };

    services.seatd = {
      enable = true;
    };

    users.users.${config.user.name} = {
      extraGroups = ["video" "seat"];
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

  flake.homeModules.hyprland = {pkgs, ...}: {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      extraConfig = ''
        source = ${self}/config/hypr/cleanup.conf
        source = ${self}/config/hypr/monitors.conf
        source = ${self}/config/hypr/programs.conf
        source = ${self}/config/hypr/autostart.conf
        source = ${self}/config/hypr/environment.conf
        source = ${self}/config/hypr/permissions.conf
        source = ${self}/config/hypr/layout.conf
        source = ${self}/config/hypr/input.conf
        source = ${self}/config/hypr/keybinds.conf
        source = ${self}/config/hypr/workspaces.conf
      '';
    };
  };
}
