{ self, ... }: {
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
      imports = [
        self.homeModules.emacsEglotNix
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
          extraPackages = with pkgs; [
            vscode-langservers-extracted
            yaml-language-server
            lua-language-server
          ];

          extraEmacsPackages = with pkgs.emacsPackages; [
            eglot
            yaml-mode
            json-mode
            lua-mode
            go-mode
          ];

          init = ''
            (defun dotfiles/eglot-organize-imports ()
              (call-interactively 'eglot-code-action-organize-imports))

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

          initPostlude = ''
            (with-eval-after-load 'eglot
              (add-to-list 'eglot-server-programs
                  ${cfg.extraServerPrograms}
                ))
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
