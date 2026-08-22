{ self, ... }: {
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
          #################
          ### EVIL MODE ###
          #################
          epkgs.evil
          epkgs.evil-collection
          epkgs.evil-surround
          epkgs.evil-nerd-commenter

          ###################
          ### KEY BINDING ###
          ###################
          epkgs.hydra
          epkgs.general
          epkgs.which-key

          ######################
          ### USER INTERFACE ###
          ######################
          epkgs.ivy
          epkgs.ivy-rich
          epkgs.ivy-posframe
          epkgs.ivy-prescient
          epkgs.counsel
          epkgs.company
          epkgs.doom-themes
          epkgs.doom-modeline

          #######################
          ### ICONS AND FONTS ###
          #######################
          epkgs.emojify
          epkgs.ligature
          epkgs.nerd-icons
          epkgs.all-the-icons
          epkgs.all-the-icons-dired
          epkgs.all-the-icons-ivy-rich

          #############
          ### MAGIT ###
          #############
          epkgs.magit

          ################
          ### ORG MODE ###
          ################
          epkgs.org-modern
        pkgs.vscode-langservers-extracted

        ######################
        ### LANGUAGE: YAML ###
        ######################
        pkgs.yaml-language-server

        #####################
        ### LANGUAGE: LUA ###
        #####################
        pkgs.lua-language-server
      ];

      fonts.fontconfig.enable = true;
    };
}
