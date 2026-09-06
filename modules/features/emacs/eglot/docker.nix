{...}: {
  flake.homeModules.emacsEglotDocker = {
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
          dockerfmt
          dockerfile-language-server
        ];

        extraEmacsPackages = with pkgs.emacsPackages; [
          docker
          dockerfile-mode
        ];

        extraServerPrograms = ''
          '((dockerfile-mode dockerfile-ts-mode) . ("docker-langserver" "--stdio"))
        '';

        extraInit = ''
          (with-eval-after-load 'eglot
            (add-to-list 'eglot-server-programs
          	       '((dockerfile-mode dockerfile-ts-mode) . ("docker-langserver" "--stdio"))))

          (defun dotfiles/docker-hook ()
            (add-hook 'before-save-hook 'eglot-format-buffer)
            (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

          (add-hook 'dockerfile-mode-hook 'eglot-ensure)
          (add-hook 'dockerfile-mode-hook #'dotfiles/docker-hook)

        '';

        extraBinds = ''
          "n" '(:ignore t :which-key "Containers")
          "nd" '(docker :which-key "Docker")
        '';
      };
    };
  };
}
