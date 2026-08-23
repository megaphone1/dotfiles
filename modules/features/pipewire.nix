{ ... }:
{
  flake.nixosModules.pipewire = { config, ... }: {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      systemWide = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    users.users.${config.user.name}.extraGroups = [
      "audio"
      "pipewire"
    ];
  };
}
