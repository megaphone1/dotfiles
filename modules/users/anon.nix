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
      self.homeModules.godot
      self.homeModules.golang
      self.homeModules.fetch
      self.homeModules.yazi
      self.homeModules.zen
      self.homeModules.nix
    ];

    config = {
      user = {
        name = "anon";
        icon = "${self/docs/avatar.png}";
        fullName = "Anonymous";
        email = "anon@devnull.com";
        key = "ABCD1234";
        location = "Edmonton, Alberta, Canada";
        timeZone = "America / Edmonton";
      };

      emacs = {
        enable = true;
        leader = "SPC";
      };

      godot.enable = true;
      golang.enable = true;

      home.stateVersion = "26.05";
    };
  };
}
