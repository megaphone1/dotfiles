{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.qemuUsers = {
    config,
    system,
    ...
  }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      extraSpecialArgs = {inherit system;};
      backupFileExtension = "backup";
      users.${config.user.name} = self.homeConfigurations.${config.user.name};
    };

    users.users.${config.user.name} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };
}
