{...}: {
  flake.homeModules.git = {
    lib,
    pkgs,
    config,
    ...
  }: let
    myCfg = config.git;
    myUserCfg = config.user;
    myEmacsCfg = config.emacs;
    myGitFix = pkgs.writeShellScriptBin "git-fix" ''
      if [ -d .git/objects/ ]; then
        find .git/objects/ -type f -empty | xargs rm -f
        git fetch -p
        git fsck --full
      fi
      exit 1
    '';
  in {
    options.git = {
      enable = lib.mkEnableOption;

      signCommits = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Should commits be signed with the users gpg key?
        '';
      };
    };

    config = lib.mkIf myCfg.enable {
      home.packages = [myGitFix];

      programs.git = {
        enable = true;

        settings = {
          user = {
            name = myUserCfg.fullName;
            email = myUserCfg.email;
          };
        };

        singing = lib.mkIf myCfg.signCommits {
          signByDefault = true;
          key = myUserCfg.key;
        };
      };

      emacs = lib.mkIf myEmacsCfg.enable {
        extraEmacsPackages = with pkgs.emacsPackages; [
          magit
        ];

        extraBinds = ''
          "g" '(:ignore t :which-key "Magit")
          "gg" '(magit-status :which-key "Status")
          "gc" '(magit-clone :which-key "Clone")
          "gf" '(magit-fetch :which-key "Fetch")
          "gp" '(magit-pull :which-key "Pull")
        '';
      };
    };
  };
}
