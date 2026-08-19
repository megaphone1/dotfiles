{ self, ... }:
{
  flake.homeConfigurations.anon =
    { ... }:
    {
      imports = [
        self.homeModules.user
        self.homeModules.stylix
        self.homeModules.xdg
        self.homeModules.git
        self.homeModules.gpg
        self.homeModules.emacs
        self.homeModules.ghostty
        self.homeModules.starship
        self.homeModules.hyprland
        self.homeModules.noctalia
        self.homeModules.mpvpaper
        self.homeModules.firefox
        self.homeModules.golang
        self.homeModules.godot
      ];

      home.stateVersion = "26.05";
    };
}
