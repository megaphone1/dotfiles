{...}: {
  flake.homeModules.godot = {
    lib,
    pkgs,
    config,
    ...
  }: let
    myCfg = config.godot;
    myEmacsCfg = config.emacs;
    myDotnetPackage = pkgs.dotnetCorePackages.sdk_8_0-bin;
  in {
    options.godot = {
      enable = lib.mkEnableOption "";
    };

    config = lib.mkIf myCfg.enable {
      home.packages = with pkgs; [
        godot-mono
        omnisharp-roslyn
        myDotnetPackage
      ];

      home.sessionVariables = {
        DOTNET_ROOT = "${myDotnetPackage}";
      };

      emacs = lib.mkIf myEmacsCfg.enable {
        extraEmacsPackages = with pkgs.emacsPackages; [
          csharp-mode
          gdscript-mode
        ];

        extraServerPrograms = ''
         '((csharp-mode csharp-ts-mode) . ("omnisharp" "-lsp"))
         '(gdscript-mode . ("localhost" 6005))
        '';

        extraInit = ''
          (defun dotfiles/godot-hook ()
            (add-hook 'before-save-hook 'eglot-format-buffer)
            (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

          (add-hook 'csharp-mode-hook 'eglot-ensure)
          (add-hook 'csharp-mode-hook #'dotfiles/godot-hook)

          (add-hook 'gdscript-mode-hook 'eglot-ensure)
          (add-hook 'gdscript-mode-hook #'dotfiles/godot-hook)
        '';
      };
    };
  };
}
