{ ... }: {
  flake.homeModules.emacsGit =
    { lib, config, ... }:
    let
      cfg = config.emacs;
    in
    {
      config.emacs = {
        extraEmacsPackages = epkgs: [
          epkgs.magit
        ];

        keys.bind = ''
          "g" '(:ignore t :which-key "Magit")
          "gg" '(magit-status :which-key "Status")
          "gc" '(magit-clone :which-key "Clone")
          "gf" '(magit-fetch :which-key "Fetch")
          "gp" '(magit-pull :which-key "Pull")
        '';
      };
    };
}
