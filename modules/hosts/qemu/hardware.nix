{ ... }: {
  flake.nixosModules.qemuHardware =
    { pkgs, modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
      ];
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
    };
}
