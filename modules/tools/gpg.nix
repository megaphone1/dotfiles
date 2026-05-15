{
  flake.homeModules.gpg =
    { pkgs, ... }:
    {
      programs.gpg.enable = true;
      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        enableSshSupport = true;
        pinentry = {
          program = "pinentry-gtk2";
          package = pkgs.pinentry-gtk2;
        };
      };
    };
}
