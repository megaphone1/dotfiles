{ self, inputs, ... }: {
  flake.nixosModules.qemuConfiguration =
    {
      lib,
      pkgs,
      config,
      system,
      modulesPath,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager

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

        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = true;
        extraSpecialArgs = { inherit system; };
        backupFileExtension = "backup";
        users.${config.user.name} = self.homeConfigurations.${config.user.name};
      };

      networking.hostName = "qemu";
      networking.networkmanager.enable = true;

      time.timeZone = config.user.timeZone;

      users.users.${config.user.name} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      nixpkgs.hostPlatform = lib.mkDefault system;
      system.stateVersion = "26.05";
    };
}
