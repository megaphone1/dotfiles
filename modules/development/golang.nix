{
  flake.homeModules.golang =
    { pkgs, config, ... }:
    {
      home.packages = [
        pkgs.gopls
      ];

      home.sessionVariables = {
        GOPATH = "/home/${config.user.name}/.local/share/go";
        GOBIN = "/home/${config.user.name}/.local/share/go/bin";
      };

      programs.go = {
        enable = true;
        env = {
          goPath = "/home/${config.user.name}/.local/share/go";
          goBin = "/home/${config.user.name}/.locl/share/go/bin";
        };
      };
    };
}
