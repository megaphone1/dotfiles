{
  self,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
  flake.nixosConfigurations.qemu = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit system;
    };

    modules = [
      self.nixosModules.qemuConfiguration
      self.nixosModules.qemuHardware
      self.nixosModules.qemuUsers
    ];
  };
}
