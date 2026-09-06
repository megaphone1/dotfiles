{...}: {
  flake.homeModules._emacs_keys = {
    lib,
    pkgs,
    config,
    ...
  }: let
    cfg = config.emacs;
  in {
    options.emacs = {
      leader = lib.mkOption {
        type = lib.types.str;
        default = "SPC";
        description = ''
          Leader key for custom keybindings.
        '';
      };

      extraMacros = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Hydra macros to be defined before binds.
        '';
      };

      extraBinds = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Keybindings to be setup with the leader key.
        '';
      };
    };

    config = lib.mkIf cfg.enable {
      emacs = {
        extraEmacsPackages = with pkgs.emacsPackages; [
          evil
          evil-collection
          evil-surround
          evil-nerd-commenter
          hydra
          general
          which-key
        ];

        extraInitPrelude = ''
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
            :prefix "${cfg.leader}"
            :global-prefix "C-${cfg.leader}")

          (setq general-evil-setup t)
        '';

        extraInitPostlude = ''
          ${cfg.extraMacros}

          (dotfiles/leader ${cfg.extraBinds})
        '';

        extraBinds = ''
          "." '(find-file :which-key "File")
          "," '(switch-to-buffer :which-key "Buffer")
          "k" '(kill-buffer :which-key "Kill")
          "c" '(kill-buffer-and-window :which-key "Close")

          "q" '(:ignore t :which-key "Quit")
          "qq" '(save-buffers-kill-emacs :which-key "Save")
          "qw" '(kill-emacs :which-key "Now")
          "qf" '(delete-frame :which-key "Frame")

          "s" '((lambda () (interactive) (switch-to-buffer "*scratch*")) :which-key "Scratch")
        '';
      };
    };
  };
}
