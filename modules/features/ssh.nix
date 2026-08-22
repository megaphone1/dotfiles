{
  flake.nixosModules.ssh = {config, ...}: {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        # AllowedUsers = ["${config.user.name}"];
      };
    };
  };
}
