{lib, ...}: let
  myUserOptions = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "anon";
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
in {
  flake.homeModules.user = {
    options.user = myUserOptions;
  };

  flake.nixosModules.user = {
    options.user = myUserOptions;
  };
}
