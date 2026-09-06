{...}: {
  flake.homeModules._emacs_eglot_golang = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.emacs;
  in {
    config = lib.mkIf cfg.enable {
      programs.go = {
        enable = true;
        env = {
          goPath = "~/.local/share/go";
          goBin = "~/.local/share/go/bin";
        };
      };

      emacs = {
        extraPackages = with pkgs; [
          gopls
        ];

        extraEmacsPackages = with pkgs.emacsPackages; [
          go-mode
        ];

        extraServerPrograms = ''
          '((go-mode go-ts-mode) . ("gopls"))
        '';

        extraInit = ''
          (defun dotfiles/go-hook ()
            (add-hook 'before-save-hook 'eglot-format-buffer)
            (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

          (add-hook 'go-mode-hook 'eglot-ensure)
          (add-hook 'go-mode-hook #'dotfiles/go-hook)
        '';
      };
    };
  };
}
