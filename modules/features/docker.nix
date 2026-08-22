{ ... }:
{
  flake.nixosModules.docker =
    { pkgs, config, ... }:
    let
      myDockerNuke = pkgs.writeShellScriptBin "docker-nuke" ''
        docker stop $(docker ps -aq)
        docker rm $(docker ps -aq)

        docker network prune -f
        docker rmi -f $(docker images --filter dangling=true -qa)
        docker volume rm $(docker volume ls --filter dangling=true -q)
        docker rmi -f $(docker images -qa)
      '';
    in
    {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune.enable = true;
      };

      users.users.${config.user.name}.extraGroups = [ "docker" ];

      environment.systemPackages = [
        myDockerNuke
      ];

      environment.variables = {
        DOCKER_CONFIG = "/home/${config.user.name}/.config/docker";
      };
    };
}
