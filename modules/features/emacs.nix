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
          epkgs.org
          epkgs.org-modern
          epkgs.org-roam
          epkgs.org-roam-ui
          epkgs.websocket
          epkgs.simple-httpd

          ########################
          ### LANGUAGE SERVERS ###
          ########################
          epkgs.eglot

          #####################
          ### LANGUAGE: NIX ###
          #####################
          epkgs.nix-mode
          epkgs.nix-ts-mode

          ########################
          ### LANGUAGE: DOCKER ###
          ########################
          epkgs.docker
          epkgs.dockerfile-mode

          #####################
          ### LANGAGE: YAML ###
          #####################
          epkgs.yaml-mode

          #####################
          ### LANGUAEG: LUA ###
          #####################
          epkgs.lua-mode

          ########################
          ### LANGUAGE: GOLANG ###
          ########################
          epkgs.go-mode

          ##########################
          ### LANGUAGE: GDSCRIPT ###
          ##########################
          epkgs.gdscript-mode
        ];
      };

      home.file.".config/emacs/init.el".source = "${self}/config/emacs/init.el";
      home.file.".config/emacs/early-init.el".source = "${self}/config/emacs/early-init.el";

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

      home.packages = [
        ###############
        ### SYMBOLS ###
        ###############
        pkgs.fira-code-symbols
        pkgs.emacs-all-the-icons-fonts

        #####################
        ### LANGUAGE: NIX ###
        #####################
        pkgs.nil
        pkgs.alejandra

        ########################
        ### LANGUAGE: DOCKER ###
        ########################
        pkgs.dockerfmt
        pkgs.dockerfile-language-server

        ######################
        ### LANGUAGE: HTML ###
        ######################
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
