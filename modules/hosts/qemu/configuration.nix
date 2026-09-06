{ self, ... }: {
  flake.nixosModules.qemuConfiguration =
    {
      lib,
      pkgs,
      config,
      system,
      ...
    }:
    {
      imports = [
        self.nixosModules.nix
        self.nixosModules.user
        self.nixosModules.stylix
        self.nixosModules.ssh
        self.nixosModules.fish
        self.nixosModules.docker
        self.nixosModules.ghostty
        self.nixosModules.hyprland
        self.nixosModules.noctalia
        self.nixosModules.pipewire
        self.nixosModules.neovim
        self.nixosModules.yazi
      ];

      networking.hostName = "qemu";
      networking.networkmanager.enable = true;

      time.timeZone = config.user.timeZone;

      nixpkgs.hostPlatform = lib.mkDefault system;
      system.stateVersion = "26.05";
    };
}
