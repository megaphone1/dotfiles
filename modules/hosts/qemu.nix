{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.qemu = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostQemu
    ];
  };

  flake.nixosModules.hostQemu =
    {
      lib,
      pkgs,
      config,
      modulesPath,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager

        self.nixosModules.nix
        self.nixosModules.user
        self.nixosModules.cachix
        self.nixosModules.stylix
        self.nixosModules.ssh
        self.nixosModules.fish
        self.nixosModules.docker
        self.nixosModules.ghostty
        self.nixosModules.hyprland
        self.nixosModules.noctalia
        self.nixosModules.neovim

        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = true;
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

      boot = {
        loader.grub = {
          enable = true;
          device = "/dev/sda";
        };

        kernelPackages = pkgs.linuxPackages_latest;
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
        initrd = {
          availableKernelModules = [
            "ahci"
            "sd_mod"
            "sr_mod"
          ];
          kernelModules = [ ];
        };
      };

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/d3b92541-f866-447f-99a2-9a7b164fc5ed";
        fsType = "ext4";
      };

      swapDevices = [
        {
          device = "/dev/disk/by-uuid/f52bfa51-6da2-4c65-8b6e-752e8d657b8f";
        }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      system.stateVersion = "26.05";
    };
}
