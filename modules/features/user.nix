{ self, lib, ... }:
let
  myUserOptions = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "anon";
    };

    icon = lib.mkOption {
      type = lib.types.str;
      default = "${self}/docs/avatar.png";
    };

    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Anonymous";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = "anon@devnull.com";
    };

    key = lib.mkOption {
      type = lib.types.str;
      default = "ABCD1234";
    };

    location = lib.mkOption {
      type = lib.types.str;
      default = "Edmonton, Canada";
    };

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/Edmonton";
    };
  };
in
{
  flake.homeModules.user = {
    options.user = myUserOptions;
  };

  flake.nixosModules.user = { config, ... }: {
    options.user = myUserOptions;

    config = {
      services.accounts-daemon.enable = true;

      systemd.tmpfiles.rules = [
        "d /var/lib/AccountsService/icons 0755 root root -"
        "C+ /var/lib/AccountsService/icons/${config.user.name} 0644 root root - ${config.user.icon}"

        "d /var/lib/AccountsService/users 0700 root root -"
        "f+ /var/lib/AccountsService/users/${config.user.name} 0600 root root - [User]\nIcon=/var/lib/AccountsService/icons/${config.user.name}\n"
      ];
    };
  };
}
