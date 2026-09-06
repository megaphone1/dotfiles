{...}: {
  flake.homeModules._emacs_eglot_yaml = {
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
          yaml-language-server
        ];

        extraEmacsPackages = with pkgs.emacsPackages; [
          yaml-mode
        ];

        extraServerPrograms = ''
          '((yaml-mode yaml-ts-mode) . ("yaml-language-server" "--stdio"))))
        '';

        extraInit = ''
          (defun dotfiles/yaml-hook ()
            (add-hook 'before-save-hook 'eglot-format-buffer)
            (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

          (add-hook 'yaml-mode-hook 'eglot-ensure)
          (add-hook 'yaml-mode-hook #'dotfiles/yaml-hook)
        '';
      };
    };
  };
}
