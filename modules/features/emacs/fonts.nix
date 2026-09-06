{ ... }:
{
  flake.homeModules.emacsFonts =
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
        config.emacs = {
          extraPackages = [
            pkgs.fira-code-symbols
            pkgs.emacs-all-the-icons-fonts
          ];

          extraEmacsPackages = epkgs: [
            epkgs.emojify
            epkgs.ligature
            epkgs.nerd-icons
            epkgs.all-the-icons
            epkgs.all-the-icons-dired
            epkgs.all-the-icons-ivy-rich
          ];

          init = ''
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

          '';

          keys = {
            macro = ''
              (defhydra hydra-text-scale (:timeout 4)
                "Scale the text in the current buffer."
                ("k" text-scale-decrease "Decrease")
                ("j" text-scale-increase "Increase")
                ("f" nil "Finished" :exit t))
            '';

            bind = ''
              "tf" '(hydra-text-scale/body :which-key "Font")
            '';
          };
        };
      };
    };
}
