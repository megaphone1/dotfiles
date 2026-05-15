{
  flake.homeModules.godot =
    { pkgs, config, ... }:
    {
      home.packages = [
        pkgs.godot
      ];
    };
}
