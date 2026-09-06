{...}: {
  flake.homeModules._emacs_git = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.emacs;
  in {
    config = lib.mkIf cfg.enable {
      emacs = {
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
