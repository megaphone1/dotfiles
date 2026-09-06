{ self, ... }:
{
  flake.homeModules.emacsOrg =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.emacs;
      orgModernIndentUrl = "https://github.com/jdtsmith/org-modern-indent";
      orgModernIndentDir = "/home/${config.user.name}/.local/share/org-modern-indent";
    in
    {
      config = lib.mkIf cfg.enable {
        home.activation = {
          cloneOrgModernIndent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if [ -d "${orgModernIndentDir}" ]; then
               (cd "${orgModernIndentDir}" && ${pkgs.git}/bin/git pull)
            else
               ${pkgs.git}/bin/git clone --depth=1 "${orgModernIndentUrl}" "${orgModernIndentDir}"
            fi
          '';
        };

        emacs = {
          extraEmacsPackages = with pkgs.emacsPackages; [
            org
            org-modern
          ];

          init = ''
            (setq org-src-fontify-natively t
                  org-src-tabs-act-natively t
                  org-hide-emphasis-markers t
                  org-src-preserve-indentation t
                  org-confirm-babel-evaluate nil)

            (add-hook 'org-mode-hook
            	  (lambda ()
            	    (visual-line-mode)))

            (add-hook 'org-tab-first-hook
            	  (lambda ()
            	    (when (org-in-src-block-p t)
            	      (let* ((elt (org-element-at-point))
            		     (lang (intern (org-element-property :language elt)))
            		     (langs org-babel-load-languages))
            		(unless (alist-get lang langs)
            		  (insert (make-string 4 ?\s)))))))

            (setq org-export-html-validation-link nil
                  org-html-validation-link nil)

            (setq org-todo-keywords '((sequence "TODO" "START" "WAIT" "DONE")))
            (setq org-image-actual-width nil)

            (setq org-modern-star 'replace)
            (setq org-auto-align-tags nil
                  org-tags-column 0
                  org-catch-invisible-edits 'show-and-error
                  org-special-ctrl-a/e t
                  org-insert-heading-respect-content t
                  org-hide-emphasis-markers t
                  org-pretty-entities t
                  org-agenda-tag-column 0
                  org-elipsis "...")

            (with-eval-after-load 'org (global-org-modern-mode))

            (add-to-list 'load-path (expand-file-name "${orgModernIndentDir}"))
            (require 'org-modern-indent)
            (add-hook 'org-mode-hook #'org-modern-indent-mode 90)
          '';

          keys.bind = ''
            "o" '(:ignore t :which-key "Org")
            "oe" '(org-export-dispatch :which-key "Export")
            "ot" '(org-babel-tangle :which-key "Tangle")
            "oi" '(org-toggle-inline-images :which-key "Images")
            "of" '(:ignore t :which-key "Footnotes")
            "ofn" '(org-footnote-normalize :which-key "Normalize")
          '';
        };
      };
    };
}
