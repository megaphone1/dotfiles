{ self, ... }: {
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
