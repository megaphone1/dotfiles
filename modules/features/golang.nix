{...}: {
  flake.homeModules.golang = {
    lib,
    pkgs,
    config,
    ...
  }: let
    myCfg = config.golang;
    myEmacsCfg = config.emacs;
    myUserName = config.user.name;
  in {
    options.golang = {
      enable = lib.mkEnableOption "";
    };

    config = lib.mkIf myCfg.enable {
      programs.go = {
        enable = true;
        env = {
          goPath = "/home/${myUserName}/.local/share/go";
          goBin = "/home/${myUserName}/.local/share/go/bin";
        };
      };

      emacs = lib.mkIf myEmacsCfg.enable {
        extraPackages = with pkgs; [
          gopls
        ];

        extraEmacsPackages = with pkgs.emacsPackages; [
          go-mode
        ];

        extraServerPrograms = ''
          '((go-mode go-ts-mode) . ("gopls"))
        '';

        extraInit = ''
          (defun dotfiles/go-hook ()
            (add-hook 'before-save-hook 'eglot-format-buffer)
            (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

          (add-hook 'go-mode-hook 'eglot-ensure)
          (add-hook 'go-mode-hook #'dotfiles/go-hook)
        '';
      };
    };
  };
}
