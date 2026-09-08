{self, ...}: {
  flake.nixosModules.all = {...}: {
    imports = [
      self.nixosModules.nix
      self.nixosModules.user
      self.nixosModules.stylix
      self.nixosModules.ssh
      self.nixosModules.fish
      self.nixosModules.ghostty
      self.nixosModules.hyprland
      self.nixosModules.noctalia
      self.nixosModules.pipewire
      self.nixosModules.neovim
      self.nixosModules.yazi
    ];
  };

  flake.homeModules.all = {...}: {
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
  };
}
