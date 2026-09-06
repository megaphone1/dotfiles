{...}: {
  flake.homeModules.emacsInterface = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.emacs;
  in {
    config = lib.mkIf cfg.enable {
      emacs = {
        extraEmacsPackages = with pkgs.emacsPackages; [
          ivy
          ivy-rich
          ivy-posframe
          ivy-prescient
          counsel
          company
          doom-themes
          doom-modeline
        ];

        earlyInit = ''
          (tooltip-mode -1)
          (tool-bar-mode -1)
          (menu-bar-mode -1)
          (scroll-bar-mode -1)

          (setq use-short-answers t)
          (setq scroll-conservatively 101)

          (setq inhibit-startup-screen t)
          (setq native-comp-async-report-warnings-errors nil)
          (setq make-backup-files nil
                auto-save-default nil
                create-lockfiles nil)

          (setq mouse-wheel-follow-mouse t
                mouse-wheel-progressive-speed t
                mouse-wheel-scroll-amount '(3 ((shift) . 3)))

        '';

        init = ''
          (setq display-line-numbers-type 'relative
                display-line-numbers-width 1
                display-line-numbers-grow-only t)

          (add-hook 'prog-mode-hook 'display-line-numbers-mode)

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

          (require 'dired-x)
          (setq dired-kill-when-opening-new-dired-buffer t)

          (evil-collection-define-key 'normal 'dired-mode-map
            "h" 'dired-up-directory
            "l" 'dired-find-file)
        '';

        keys = {
          macro = ''
            (defhydra hydra-resize-frame (:timeout 4)
              "Scale the current frame."
              ("h" shrink-window-horizontally "Left")
              ("j" enlarge-window "Down")
              ("k" shrink-window "Up")
              ("l" enlarge-window-horizontally "Right")
              ("f" nil "Finished" :exit t))
          '';

          bind = ''
            "t" '(:ignore t :which-key "Toggle / Tweak")
            "tl" '(display-line-numbers-mode :which-key "Line Numbers")

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

            "wr" '(hydra-resize-frame/body :which-key "Resize")

            "d" '(:ignore t :which-key "Dired")
            "dd" '(dired-jump :which-key "Dired")
            "dc" '((lambda () (interactive) (dired "/etc/nixos/")) :which-key "Config")
          '';
        };
      };
    };
  };
}
