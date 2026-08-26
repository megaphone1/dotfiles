{ self, ... }: {
  flake.homeModules.fetch = { ... }:
    {
      programs.fastfetch = {
        enable = true;
        settings = {

          display = {
            separator = " ";
            color = "white";
          };

          logo = {
            type = "kitty";
            source = "${self}/docs/fetch.png";
            height = 16;
            width = 32;
          };

          modules = [
            "break"
            "break"
            "break"
            {
              type = "custom";
              key = "╭─────────────────────────────────────────╮";
            }
            {
              type = "custom";
              key = "│                                         │";
            }
            {
              type = "os";
              key = "│  OS            ";
              format = "{pretty-name>22}  │";
            }
            {
              type = "command";
              key = "│  Kernel        ";
              text = "uname -r | cut -d '-' -f1";
              format = "{>22}  │";
            }
            {
              type = "shell";
              key = "│  Shell         ";
              format = "{pretty-name>22}  │";
            }
            {
              type = "command";
              key = "│  Desktop       ";
              text = "echo $XDG_CURRENT_DESKTOP";
              format = "{>22}  │";
            }
            {
              type = "packages";
              key = "│  Packages      ";
              format = "{all>22}  │";
            }
            {

              type = "custom";
              key = "│                                         │";
            }
            {
              type = "custom";
              key = "╰─────────────────────────────────────────╯";
            }
          ];
        };
      };
    };
}
