{self, ...}: {
  flake.homeConfigurations.anon = {...}: {
    imports = [
      self.homeModules.user
      self.homeModules.stylix
      self.homeModules.git
      self.homeModules.gpg
      self.homeModules.emacs
      self.homeModules.ghostty
      self.homeModules.starship
      self.homeModules.hyprland
      self.homeModules.noctalia
      self.homeModules.spicetify
      self.homeModules.firefox
      self.homeModules.golang
      self.homeModules.yazi
    ];

    home.stateVersion = "26.05";
  };
}
