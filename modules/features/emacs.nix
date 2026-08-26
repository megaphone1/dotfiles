{ inputs, ... }: {
  flake.homeModules.emacs =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      emacsPkg = pkgs.emacs-pgtk;
    in
    {
      services.emacs = {
        enable = true;
        package = emacsPkg;
      };

      programs.emacs = {
        enable = true;
        package = emacsPkg;
        extraPackages = epkgs: [
          epkgs.evil
          epkgs.evil-collection
          epkgs.evil-surround
          epkgs.evil-nerd-commenter
          epkgs.hydra
          epkgs.general
          epkgs.which-key
          epkgs.ivy
          epkgs.ivy-rich
          epkgs.ivy-posframe
          epkgs.ivy-prescient
          epkgs.counsel
          epkgs.company
          epkgs.doom-themes
          epkgs.doom-modeline
          epkgs.emojify
          epkgs.ligature
          epkgs.nerd-icons
          epkgs.all-the-icons
          epkgs.all-the-icons-dired
          epkgs.all-the-icons-ivy-rich
          epkgs.magit
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
        ];
      };

      home.packages = [
        pkgs.fira-code-symbols
        pkgs.emacs-all-the-icons-fonts
        pkgs.nil
        pkgs.alejandra
        pkgs.dockerfmt
        pkgs.dockerfile-language-server
        pkgs.vscode-langservers-extracted
        pkgs.yaml-language-server
        pkgs.lua-language-server
      ];

      fonts.fontconfig.enable = true;

      home.activation =
        let
          orgModernUrl = "https://github.com/jdtsmith/org-modern-indent";
          orgModernDir = "/home/${config.user.name}/.local/share/org-modern-indent";
          orgRoamDirectory = "/home/${config.user.name}/.local/share/Documents";
        in
        {
          cloneOrgModernIndent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if [ -d "${orgModernDir}" ]; then
               (cd "${orgModernDir}" && ${pkgs.git}/bin/git pull)
            else
               ${pkgs.git}/bin/git clone --depth=1 "${orgModernUrl}" "${orgModernDir}"
            fi
          '';
          createOrgRoamDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            mkdir -p ${orgRoamDirectory}
          '';
        };

      home.file.".config/emacs/early-init.el".text = ''
        (tooltip-mode -1)
        (tool-bar-mode -1)
        (menu-bar-mode -1)
        (scroll-bar-mode -1)

        (setq inhibit-startup-screen t)

        (setq make-backup-files nil
              auto-save-default nil
              create-lockfiles nil)

        (setq use-short-answers t)
        (setq scroll-conservatively 101)

        (setq mouse-wheel-follow-mouse t
              mouse-wheel-progressive-speed t
              mouse-wheel-scroll-amount '(3 ((shift) . 3)))

        (setq native-comp-async-report-warnings-errors nil)
      '';

      home.file.".config/emacs/init.el".text = ''
        (setq evil-want-integration t
              evil-want-keybinding nil
              evil-want-C-i-jump nil)
        (evil-mode +1)
        (evil-collection-init)
        (global-evil-surround-mode +1)

        (global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)

        (setq which-key-idle-delay 0.0)
        (which-key-mode +1)

        (general-create-definer dotfiles/leader
          :keymaps `(normal insert visual emacs)
          :prefix "SPC"
          :global-prefix "C-SPC")

        (setq general-evil-setup t)

        (dotfiles/leader
         "." '(find-file :which-key "File")
         "," '(switch-to-buffer :which-key "Buffer")
         "k" '(kill-buffer :which-key "Kill")
         "c" '(kill-buffer-and-window :which-key "Close"))

        (dotfiles/leader
          "q" '(:ignore t :which-key "Quit")
          "qq" '(save-buffers-kill-emacs :which-key "Save")
          "qw" '(kill-emacs :which-key "Now")
          "qf" '(delete-frame :which-key "Frame"))

        (dotfiles/leader
          "t" '(:ignore t :which-key "Toggle / Tweak"))

        (dotfiles/leader
          "s" '((lambda () (interactive) (switch-to-buffer "*scratch*")) :which-key "Scratch"))

        (setq display-line-numbers-type 'relative
              display-line-numbers-width 1
              display-line-numbers-grow-only t)

        (add-hook 'prog-mode-hook 'display-line-numbers-mode)

        (dotfiles/leader
          "tl" '(display-line-numbers-mode :which-key "Line Numbers"))

        (setq counsel-linux-app-format-function
              #'counsel-linux-app-format-function-name-only)
        (ivy-mode +1)
        (counsel-mode +1)
        (ivy-rich-mode +1)

        (setq ivy-posframe-parameters '((parent-frame nil))
              ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
        (ivy-posframe-mode +1)

        (setq ivy-prescient-enable-filtering nil)
        (ivy-prescient-mode +1)

        (setq company-backend 'company-capf)
        (global-company-mode +1)

        (setq doom-modeline-height 16
              doom-modeline-icon t)

        (add-hook 'after-init-hook 'doom-modeline-mode)

        (defhydra hydra-resize-frame (:timeout 4)
          "Scale the current frame."
          ("h" shrink-window-horizontally "Left")
          ("j" enlarge-window "Down")
          ("k" shrink-window "Up")
          ("l" enlarge-window-horizontally "Right")
          ("f" nil "Finished" :exit t))

        (dotfiles/leader
          "w" '(:ignore t :which-key "Windows")
          "ww" '(window-swap-states :which-key "Swap")
          "wc" '(delete-window :which-key "Close")
          "wh" '(windmove-left :which-key "Left")
          "wj" '(windmove-down :which-key "Down")
          "wk" '(windmove-up :which-key "Up")
          "wl" '(windmove-right :which-key "Right")
          "ws" '(:ignore t :which-key "Split")
          "wsj" '(split-window-below :which-key "Below")
          "wsl" '(split-window-right :which-key "Right")
          "wr" '(hydra-resize-frame/body :which-key "Resize"))

        (add-hook 'after-init-hook 'global-emojify-mode)

        (ligature-set-ligatures 't '("www"))
        (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
        (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                             ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                             "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                             "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                             "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                             "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                             "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                             "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                             ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                             "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                             "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                             "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                             "\\\\" "://"))

        (global-ligature-mode t)
        (global-prettify-symbols-mode +1)

        (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
        (setq all-the-icons-dired-monochrome nil)
        (all-the-icons-ivy-rich-mode +1)

        (defhydra hydra-text-scale (:timeout 4)
          "Scale the text in the current buffer."
          ("k" text-scale-decrease "Decrease")
          ("j" text-scale-increase "Increase")
          ("f" nil "Finished" :exit t))

        (dotfiles/leader
          "tf" '(hydra-text-scale/body :which-key "Font"))

        (require 'dired-x)
        (setq dired-kill-when-opening-new-dired-buffer t)

        (evil-collection-define-key 'normal 'dired-mode-map
          "h" 'dired-up-directory
          "l" 'dired-find-file)

        (dotfiles/leader
          "d" '(:ignore t :which-key "Dired")
          "dd" '(dired-jump :which-key "Dired")
          "dc" '((lambda () (interactive) (dired "/etc/nixos/")) :which-key "Config"))

        (dotfiles/leader
          "g" '(:ignore t :which-key "Magit")
          "gg" '(magit-status :which-key "Status")
          "gc" '(magit-clone :which-key "Clone")
          "gf" '(magit-fetch :which-key "Fetch")
          "gp" '(magit-pull :which-key "Pull"))

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
}
