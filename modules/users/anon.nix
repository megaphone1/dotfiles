{self, ...}: {
  flake.homeConfigurations.anon = {...}: {
    imports = [
      self.homeModules.user
      self.homeModules.stylix
      self.homeModules.git
      self.homeModules.gpg
      self.homeModules.emacs
      self.homeModules.alacritty
      self.homeModules.ghostty
      self.homeModules.starship
      self.homeModules.hyprland
      self.homeModules.noctalia
      self.homeModules.firefox
      self.homeModules.golang
    ];

    home.stateVersion = "26.05";
  };
}
