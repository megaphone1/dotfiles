{...}: {
  flake.nixosModules.nix = {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
    };

    nixpkgs.config = {
      allowUnfree = true;
    };
  };

  flake.homeModules.nix = {
    lib,
    pkgs,
    config,
    ...
  }: let
    myEmacsCfg = config.emacs;
  in {
    config = lib.mkIf myEmacsCfg.enable {
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
