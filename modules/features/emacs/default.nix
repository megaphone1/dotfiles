{self, ...}: {
  flake.homeModules.emacs = {
    lib,
    pkgs,
    config,
    system,
    ...
  }: let
    cfg = config.emacs;
    emacsPkg = pkgs.emacs-pgtk;
  in {
    imports = [
      self.homeModules.emacsKeys
      self.homeModules.emacsInterface
      self.homeModules.emacsFonts
      self.homeModules.emacsGit
      self.homeModules.emacsOrg
      self.homeModules.emacsEglot
    ];

    options.emacs = {
      enable = lib.mkEnableOption "";

      extraEarlyInit = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration lines to add to early-init.el
        '';
      };

      extraInitPrelude = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configurtion lines to add to the start of init.el
        '';
      };

      extraInitPostlude = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration lines to add to the end of init.el
        '';
      };

      extraInit = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Configuration lines to add to the body of init.el
        '';
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = ''
          Extra packages to add to home.packages
        '';
      };

      extraEmacsPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
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
        extraPackages = epkgs: [] ++ cfg.extraEmacsPackages;
      };

      home.packages = [] ++ cfg.extraPackages;

      home.file.".config/emacs/early-init.el".text = ''
        ${cfg.extraEarlyInit}
      '';

      home.file.".config/emacs/init.el".text = ''
        ${cfg.extraInitPrelude}
        ${cfg.extraInit}
        ${cfg.extraInitPostlude}
      '';
    };
  };
}
