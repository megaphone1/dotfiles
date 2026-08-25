{ ... }: {
  flake.homeModules.fetch =
    { config, ... }:
    let
      colors = config.lib.stylix.colors.withHashtag;
    in
    {
      programs.fastfetch = {
        enable = true;

        settings = {
          logo = {
            type = "auto";
          };

          display = {
            color = {
              title = colors.base08;
              keys = colors.base0D;
              output = colors.base05;
            };
          };

          # modules = [
          # ];
        };
      };
    };
}
