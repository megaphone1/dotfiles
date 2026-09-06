{...}: {
  flake.homeModules._emacs_eglot_html = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.emacs;
  in {
    config = lib.mkIf cfg.enable {
      emacs = {
        extraPackages = with pkgs; [
          vscode-langservers-extracted
        ];

        extraServerPrograms = ''
          '((html-mode) . ("vscode-html-language-server" "--stdio"))
        '';

        extraInit = ''
          (defun dotfiles/html-hook ()
            (add-hook 'before-save-hook 'eglot-format-buffer))

          (add-hook 'mhtml-mode-hook 'eglot-ensure)
          (add-hook 'mhtml-mode-hook #'dotfiles/html-hook)
        '';
      };
    };
  };
}
