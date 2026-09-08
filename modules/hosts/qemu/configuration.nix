{self, ...}: {
  flake.nixosModules.qemuConfiguration = {
    lib,
    config,
    system,
    ...
  }: {
    imports = [
      self.nixosModules.all
    ];

    networking.hostName = "qemu";
    networking.networkmanager.enable = true;

    time.timeZone = config.user.timeZone;

    nixpkgs.hostPlatform = lib.mkDefault system;
    system.stateVersion = "26.05";
  };
}
