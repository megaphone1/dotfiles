{self, ...}: {
  flake.homeModules.emacsEglot = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.emacs;
  in {
    imports = [
      self.homeModules.emacsEglotNix
      self.homeModules.emacsEglotDocker
      self.homeModules.emacsEglotGolang
      self.homeModules.emacsEglotHtml
      self.homeModules.emacsEglotYaml
    ];

    options.emacs = {
      extraServerPrograms = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Additional `eglot-server-programs' to be added.
        '';
      };
    };

    config = lib.mkIf cfg.enable {
      emacs = {
        extraEmacsPackages = with pkgs.emacsPackages; [
          eglot
        ];

        extraInit = ''
          (defun dotfiles/eglot-organize-imports ()
            (call-interactively 'eglot-code-action-organize-imports))
        '';

        extraInitPostlude = ''
          (with-eval-after-load 'eglot
            (add-to-list 'eglot-server-programs
                ${cfg.extraServerPrograms}
              ))
        '';

        extraBinds = ''
          "l" '(:ignore t :which-key "Eglot")
          "ll" '(eglot :which-key "Eglot")
          "lr" '(eglot-rename :which-key "Rename")
          "lf" '(eglot-format :which-key "Format")
        '';
      };
    };
  };
}
