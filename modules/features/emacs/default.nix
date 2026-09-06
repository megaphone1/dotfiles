{ self, inputs, ... }: {
  flake.homeModules.emacs =
    {
      lib,
      pkgs,
      config,
      system,
      ...
    }:
    let
      cfg = config.emacs;
      emacsPkg = pkgs.emacs-pgtk;
    in
    {
      imports = [
        self.homeModules.emacsKeys
        self.homeModules.emacsInterface
        self.homeModules.emacsFonts
        self.homeModules.emacsGit
      ];

      options.emacs = {
        enable = lib.mkEnableOption "";

        earlyInit = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Configuration lines to add to early-init.el
          '';
        };

        initPrelude = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Configurtion lines to add to the start of init.el
          '';
        };

        initPostlude = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Configuration lines to add to the end of init.el
          '';
        };

        init = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Configuration lines to add to the body of init.el
          '';
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.packages;
          default = [ ];
          description = ''
            Extra packages to add to home.packages
          '';
        };

        extraEmacsPackages = lib.mkOption {
          type = lib.types.listOf lib.types.packages;
          default = [ ];
          description = ''
            Extra packages to add to programs.emacs.extraPackages
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        services.emacs = {
          enable = true;
          package = emacsPkg;
        };

        programs.emacs = {
          enable = true;
          package = emacsPkg;
          extraPackages =
            epkgs:
            [
              epkgs.org
              epkgs.org-modern
              epkgs.eglot
              epkgs.nix-mode
              epkgs.nix-ts-mode
              epkgs.docker
              epkgs.dockerfile-mode
              epkgs.yaml-mode
              epkgs.json-mode
              epkgs.lua-mode
              epkgs.go-mode
            ]
            ++ cfg.extraEmacsPackages;
        };

        home.packages = [
          pkgs.nil
          pkgs.alejandra
          pkgs.dockerfmt
          pkgs.dockerfile-language-server
          pkgs.vscode-langservers-extracted
          pkgs.yaml-language-server
          pkgs.lua-language-server
        ]
        ++ cfg.extraPackages;

        fonts.fontconfig.enable = true;

        home.activation =
          let
            orgModernIndentUrl = "https://github.com/jdtsmith/org-modern-indent";
            orgModernIndentDir = "/home/${config.user.name}/.local/share/org-modern-indent";
          in
          {
            cloneOrgModernIndent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              if [ -d "${orgModernIndentDir}" ]; then
                 (cd "${orgModernIndentDir}" && ${pkgs.git}/bin/git pull)
              else
                 ${pkgs.git}/bin/git clone --depth=1 "${orgModernIndentUrl}" "${orgModernIndentDir}"
              fi
            '';
          };

        home.file.".config/emacs/early-init.el".text = ''
          (setq inhibit-startup-screen t)
          (setq native-comp-async-report-warnings-errors nil)
          (setq make-backup-files nil
                auto-save-default nil
                create-lockfiles nil)

          ${cfg.earlyInit}
        '';

        home.file.".config/emacs/init.el".text = ''
          ${cfg.initPrelude}

          ${cfg.init}

          ${cfg.initPostlude}
          (setq org-src-fontify-natively t
                org-src-tabs-act-natively t
                org-hide-emphasis-markers t
                org-src-preserve-indentation t
                org-confirm-babel-evaluate nil)

          (add-hook 'org-mode-hook
          	  (lambda ()
          	    (visual-line-mode)))

          (add-hook 'org-tab-first-hook
          	  (lambda ()
          	    (when (org-in-src-block-p t)
          	      (let* ((elt (org-element-at-point))
          		     (lang (intern (org-element-property :language elt)))
          		     (langs org-babel-load-languages))
          		(unless (alist-get lang langs)
          		  (insert (make-string 4 ?\s)))))))

          (setq org-export-html-validation-link nil
                org-html-validation-link nil)

          (setq org-todo-keywords '((sequence "TODO" "START" "WAIT" "DONE")))
          (setq org-image-actual-width nil)

          (setq org-modern-star 'replace)
          (setq org-auto-align-tags nil
                org-tags-column 0
                org-catch-invisible-edits 'show-and-error
                org-special-ctrl-a/e t
                org-insert-heading-respect-content t
                org-hide-emphasis-markers t
                org-pretty-entities t
                org-agenda-tag-column 0
                org-elipsis "...")

          (with-eval-after-load 'org (global-org-modern-mode))

          (add-to-list 'load-path (expand-file-name "~/.local/share/org-modern-indent/"))
          (require 'org-modern-indent)
          (add-hook 'org-mode-hook #'org-modern-indent-mode 90)

          (dotfiles/leader
            "o" '(:ignore t :which-key "Org")
            "oe" '(org-export-dispatch :which-key "Export")
            "ot" '(org-babel-tangle :which-key "Tangle")
            "oi" '(org-toggle-inline-images :which-key "Images")
            "of" '(:ignore t :which-key "Footnotes")
            "ofn" '(org-footnote-normalize :which-key "Normalize"))

          (defun dotfiles/eglot-organize-imports ()
            (call-interactively 'eglot-code-action-organize-imports))

          (dotfiles/leader
            "l" '(:ignore t :which-key "Eglot")
            "ll" '(eglot :which-key "Eglot")
            "lr" '(eglot-rename :which-key "Rename")
            "lf" '(eglot-format :which-key "Format"))

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

          (dotfiles/leader
            "n" '(:ignore t :which-key "Containers")
            "nd" '(docker :which-key "Docker"))

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
      };
    };
}
