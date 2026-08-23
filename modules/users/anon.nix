{ self, ... }: {
  flake.homeConfigurations.anon = { ... }: {
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

    config = {
      user = {
        name = "anon";
        fullName = "Anonymous";
        email = "anon@devnull.com";
        key = "ABCD1234";
        location = "Edmonton, Alberta, Canada";
        timeZone = "America / Edmonton";
      };

      home.stateVersion = "26.05";
    };
  };
}
