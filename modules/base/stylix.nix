{ inputs, ... }:
{
  flake.homeModules.stylix =
    { pkgs, ... }:
    {
      imports = [ inputs.stylix.homeModules.stylix ];

      stylix = {
        enable = true;
        autoEnable = true;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

        opacity = {
          applications = 0.75;
          terminal = 0.75;
          desktop = 0.75;
          popups = 0.75;
        };

        cursor = {
          package = pkgs.catppuccin-cursors.mochaDark;
          name = "Catppuccin-Mocha-Dark-Cursors";
          size = 16;
        };

        fonts = {
          sizes = {
            applications = 10;
            terminal = 10;
            desktop = 10;
            popups = 10;
          };

          monospace = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font Mono";
          };

          serif = {
            package = pkgs.nerd-fonts.ubuntu;
            name = "Ubuntu Nerd Font";
          };

          sansSerif = {
            package = pkgs.nerd-fonts.ubuntu-sans;
            name = "UbuntuSans Nerd Font";
          };

          emoji = {
            package = pkgs.twitter-color-emoji;
            name = "Twitter Color Emoji";
          };
        };

        targets.firefox.profileNames = [ "default" ];
      };
    };

  flake.nixosModules.stylix =
    { config, ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];
    };
}
