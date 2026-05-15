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

          nfc = "nix flake check";
          nfu = "nix flake update";
          ncg = "sudo nix-collect-garbage -d";
          nrs = "sudo nixos-rebuild switch --flake /etc/nixos";
          nrr = "sudo nixos-rebuild switch --rollback";

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
