{
  flake.nixosModules.fish =
    {
      pkgs,
      config,
      ...
    }:
    {
      programs.fish = {
        enable = true;

        interactiveShellInit = ''
          set fish_greeting
        '';

        shellAliases = {
          v = "vim";

          cdd = "cd /etc/nixos";

          nfc = "nix flake check --accept-flake-config";
          nfu = "nix flake update --accept-flake-config";
          ncg = "sudo nix-collect-garbage -d";
          nrs = "sudo nixos-rebuild switch --flake /etc/nixos --accept-flake-config";
          nrr = "sudo nixos-rebuild switch --rollback --accept-flake-config";

          hmj = "journalctl -xe --unit home-manager-${config.user.name}";

          dcu = "docker compose up";
          dcd = "docker compose down";
        };
      };

      users.extraUsers.${config.user.name} = {
        shell = pkgs.fish;
      };
    };
}
