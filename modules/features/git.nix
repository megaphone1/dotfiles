{
  flake.homeModules.git = {
    pkgs,
    config,
    ...
  }: let
    myGitFix = pkgs.writeShellScriptBin "git-fix" ''
      if [ -d .git/objects/ ]; then
        find .git/objects/ -type f -empty | xargs rm -f
        git fetch -p
        git fsck --full
      fi
      exit 1
    '';
  in {
    home.packages = [myGitFix];

    programs.git = {
      enable = true;

      signing = {
        # signByDefault = true;
        signByDefault = false;
        key = config.user.key;
      };

      settings = {
        user.name = config.user.fullName;
        user.email = config.user.email;
      };
    };
  };
}
