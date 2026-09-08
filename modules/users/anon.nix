{self, ...}: {
  flake.homeConfigurations.anon = {...}: {
    imports = [
      self.homeModules.all
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

      git.enable = true;
      godot.enable = true;
      golang.enable = true;

      home.stateVersion = "26.05";
    };
  };
}
