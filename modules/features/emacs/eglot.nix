{ ... }: {
  flake.homeModules.emacsEglot =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.emacs;
    in
    {
      config = lib.mkIf cfg.enable {
        config.emacs = {
          extraPackages = [
            pkgs.nil
            pkgs.alejandra
            pkgs.dockerfmt
            pkgs.dockerfile-language-server
            pkgs.vscode-langservers-extracted
            pkgs.yaml-language-server
            pkgs.lua-language-server
          ];

          extraEmacsPackages = epkgs: [
            epkgs.eglot
            epkgs.nix-mode
            epkgs.nix-ts-mode
            epkgs.docker
            epkgs.dockerfile-mode
            epkgs.yaml-mode
            epkgs.json-mode
            epkgs.lua-mode
            epkgs.go-mode
          ];

          init = ''
            (defun dotfiles/eglot-organize-imports ()
              (call-interactively 'eglot-code-action-organize-imports))

            (add-hook 'nix-mode-hook 'eglot-ensure)
            (with-eval-after-load 'eglot
              (add-to-list 'eglot-server-programs
            	       '((nix-mode nix-ts-mode) . ("nil"))))

            (setq eglot-workspace-configuration '(:nix (:formattingProvider "alejandra")))

            (defun dotfiles/nix-hook ()
              (add-hook 'before-save-hook 'eglot-format-buffer)
              (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

            (add-hook 'nix-mode-hook #'dotfiles/nix-hook)
            (with-eval-after-load 'eglot
              (add-to-list 'eglot-server-programs
            	       '((dockerfile-mode dockerfile-ts-mode) . ("docker-langserver" "--stdio"))))

            (defun dotfiles/docker-hook ()
              (add-hook 'before-save-hook 'eglot-format-buffer)
              (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

            (add-hook 'dockerfile-mode-hook 'eglot-ensure)
            (add-hook 'dockerfile-mode-hook #'dotfiles/docker-hook)

            (with-eval-after-load 'eglot
              (add-to-list 'eglot-server-programs
            	       '(html-mode . ("vscode-html-language-server" "--stdio"))))

            (defun dotfiles/html-hook ()
              (add-hook 'before-save-hook 'eglot-format-buffer))

            (add-hook 'mhtml-mode-hook 'eglot-ensure)
            (add-hook 'mhtml-mode-hook #'dotfiles/html-hook)

            (with-eval-after-load 'eglot
              (add-to-list 'eglot-server-programs
            	       '((yaml-mode yaml-ts-mode) . ("yaml-language-server" "--stdio"))))

            (defun dotfiles/yaml-hook ()
              (add-hook 'before-save-hook 'eglot-format-buffer)
              (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

            (add-hook 'yaml-mode-hook 'eglot-ensure)
            (add-hook 'yaml-mode-hook #'dotfiles/yaml-hook)

            (with-eval-after-load 'eglot
              (add-to-list 'eglot-server-programs
            	       '((lua-mode) . ("lua-language-server" "--stdio"))))

            (defun dotfiles/lua-hook ()
              (add-hook 'before-save-hook 'eglot-format-buffer)
              (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

            (add-hook 'lua-mode-hook 'eglot-ensure)
            (add-hook 'lua-mode-hook #'dotfiles/lua-hook)

            (with-eval-after-load 'eglot
              (add-to-list 'eglot-server-programs
            	       '((go-mode go-ts-mode) . ("gopls"))))

            (defun dotfiles/go-hook ()
              (add-hook 'before-save-hook 'eglot-format-buffer)
              (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

            (add-hook 'go-mode-hook 'eglot-ensure)
            (add-hook 'go-mode-hook #'dotfiles/go-hook)
          '';

          keys.bind = ''
            "l" '(:ignore t :which-key "Eglot")
            "ll" '(eglot :which-key "Eglot")
            "lr" '(eglot-rename :which-key "Rename")
            "lf" '(eglot-format :which-key "Format")

            "n" '(:ignore t :which-key "Containers")
            "nd" '(docker :which-key "Docker")
          '';
        };
      };
    };
}
