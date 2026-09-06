{ ... }:
{
  flake.homeModules.emacsEglotNix =
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
        emacs = {
          extraPackages = with pkgs; [
            nixd
            alejandra
          ];

          extraEmacsPackages = with pkgs.emacsPackages; [
            nix-mode
            nix-ts-mode
          ];

          extraServerPrograms = ''
            '((nix-mode nix-ts-mode) . ("nixd"))
          '';

          extraInit = ''
            (add-hook 'nix-mode-hook 'eglot-ensure)

            (setq eglot-workspace-configuration '(:nixd (:formatting (:command ["alejandra"]))))

            (defun dotfiles/nix-hook ()
              (add-hook 'before-save-hook 'eglot-format-buffer)
              (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

            (add-hook 'nix-mode-hook #'dotfiles/nix-hook)
          '';

        };
      };
    };
}
