;;;;;;;;;;;;;;;;;;;
;;;; EVIL MODE ;;;;
;;;;;;;;;;;;;;;;;;;

;; Enable `evil-mode'.
(setq evil-want-integration t
      evil-want-keybinding nil
      evil-want-C-i-jump nil)
(evil-mode +1)

;; Configure `evil-collection'.
(evil-collection-init)

;; Configure `evil-surround'.
(global-evil-surround-mode +1)

;; Configure `evil-nerd-commenter'.
(global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)

;;;;;;;;;;;;;;;;;;;;;
;;;; KEYBINDINGS ;;;;
;;;;;;;;;;;;;;;;;;;;;

;; Configure `which-key'.
(setq which-key-idle-delay 0.0)
(which-key-mode +1)

;; Use <SPC> as a leader key.
(general-create-definer dotfiles/leader
  :keymaps `(normal insert visual emacs)
  :prefix "SPC"
  :global-prefix "C-SPC")

;; Setup general to work with evil mode.
(setq general-evil-setup t)

;; Find files with <SPC> <period>.
;; Switch buffers with <SPC> <comma>.
;; Kill buffers with <SPC> k.
;; Close windows with <SPC> c.
(dotfiles/leader
 "." '(find-file :which-key "File")
 "," '(switch-to-buffer :which-key "Buffer")
 "k" '(kill-buffer :which-key "Kill")
 "c" '(kill-buffer-and-window :which-key "Close"))

;; Quit and Save with <SPC> qq.
;; Quit immediately with <SPC> qw.
;; Quit the current frame with <SPC> qf.
(dotfiles/leader
  "q" '(:ignore t :which-key "Quit")
  "qq" '(save-buffers-kill-emacs :which-key "Save")
  "qw" '(kill-emacs :which-key "Now")
  "qf" '(delete-frame :which-key "Frame"))

;; Access toggles / tweaks with <SPC> t.
(dotfiles/leader
  "t" '(:ignore t :which-key "Toggle / Tweak"))

;; Open scratch buffer with <SPC> s.
(dotfiles/leader
  "s" '((lambda () (interactive) (switch-to-buffer "*scratch*")) :which-key "Scratch"))

;;;;;;;;;;;;;;;;;;;;;;;;
;;;; USER INTERFACE ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable relative line numbers.
(setq display-line-numbers-type 'relative
      display-line-numbers-width 1
      display-line-numbers-grow-only t)

;; Enable line numbering for all programming modes.
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Toggle line numbers with <SPC> tl.
(dotfiles/leader
  "tl" '(display-line-numbers-mode :which-key "Line Numbers"))

;; Configure `ivy'.
(setq counsel-linux-app-format-function
      #'counsel-linux-app-format-function-name-only)
(ivy-mode +1)
(counsel-mode +1)

;; Configure `ivy-rich'.
(ivy-rich-mode +1)

;; Configure `ivy-posframe'.
(setq ivy-posframe-parameters '((parent-frame nil))
      ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
(ivy-posframe-mode +1)

;; Configure `ivy-prescient'.
(setq ivy-prescient-enable-filtering nil)
(ivy-prescient-mode +1)

;; Configure `company-mode'.
(setq company-backend 'company-capf)
(global-company-mode +1)

;; Configure `doom-modeline'.
(setq doom-modeline-height 16
      doom-modeline-icon t)

;; Launch after intialization.
(add-hook 'after-init-hook 'doom-modeline-mode)

;; Define a function for resizing frames.
(defhydra hydra-resize-frame (:timeout 4)
  "Scale the current frame."
  ("h" shrink-window-horizontally "Left")
  ("j" enlarge-window "Down")
  ("k" shrink-window "Up")
  ("l" enlarge-window-horizontally "Right")
  ("f" nil "Finished" :exit t))

;; Keybindings for working with frames.
(dotfiles/leader
  "w" '(:ignore t :which-key "Windows")
  "ww" '(window-swap-states :which-key "Swap")
  "wc" '(delete-window :which-key "Close")
  "wh" '(windmove-left :which-key "Left")
  "wj" '(windmove-down :which-key "Down")
  "wk" '(windmove-up :which-key "Up")
  "wl" '(windmove-right :which-key "Right")
  "ws" '(:ignore t :which-key "Split")
  "wsj" '(split-window-below :which-key "Below")
  "wsl" '(split-window-right :which-key "Right")
  "wr" '(hydra-resize-frame/body :which-key "Resize"))

;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; ICONS AND FONTS ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Setup `emojify'.
(add-hook 'after-init-hook 'global-emojify-mode)

;; Setup `ligatures'.
(ligature-set-ligatures 't '("www"))

;; Enable traditional ligature support in eww-mode, if the
;; `variable-pitch' face supports it
(ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))

;; Enable all Cascadia Code ligatures in programming modes
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

;; Enables ligature checks globally in all buffers.
(global-ligature-mode t)
		      
;; Display default font ligatures.
(global-prettify-symbols-mode +1)

;; Setup `all-the-icons-dired'.
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; Disable monochrome icons.
(setq all-the-icons-dired-monochrome nil)

;; Setup 'all-the-icons-ivy-rich'.
(all-the-icons-ivy-rich-mode +1)

;; Define a function for scaling the text.
(defhydra hydra-text-scale (:timeout 4)
  "Scale the text in the current buffer."
  ("k" text-scale-decrease "Decrease")
  ("j" text-scale-increase "Increase")
  ("f" nil "Finished" :exit t))

(dotfiles/leader
  "tf" '(hydra-text-scale/body :which-key "Font"))

;;;;;;;;;;;;;;;
;;;; DIRED ;;;;
;;;;;;;;;;;;;;;

;; Include `dired-x' for the `jump' method.
(require 'dired-x)

;; Make `dired' reuse the same buffer.
(setq dired-kill-when-opening-new-dired-buffer t)

;; Configure `dired' to support `evil' keybindings.
(evil-collection-define-key 'normal 'dired-mode-map
  "h" 'dired-up-directory
  "l" 'dired-find-file)

;; Open dired with <SPC> d d.
;; Open system config with <SPC> d c.
(dotfiles/leader
  "d" '(:ignore t :which-key "Dired")
  "dd" '(dired-jump :which-key "Dired")
  "dc" '((lambda () (interactive) (dired "/etc/nixos/")) :which-key "Config"))

;;;;;;;;;;;;;;;
;;;; MAGIT ;;;;
;;;;;;;;;;;;;;;

;; Add keybindings for working with `magit'.
;; Open magit with <SPC> g.
;; Status with <SPC> g g.
;; Clone with <SPC> g c.
;; Fetch with <SPC> g f.
;; Pull with <SPC> g p.
(dotfiles/leader
  "g" '(:ignore t :which-key "Magit")
  "gg" '(magit-status :which-key "Status")
  "gc" '(magit-clone :which-key "Clone")
  "gf" '(magit-fetch :which-key "Fetch")
  "gp" '(magit-pull :which-key "Pull"))

;;;;;;;;;;;;;;;;;;
;;;; ORG MODE ;;;;
;;;;;;;;;;;;;;;;;;

;; Configure `org-mode' source blocks;
(setq org-src-fontify-natively t
      org-src-tabs-act-natively t
      org-hide-emphasis-markers t
      org-src-preserve-indentation t
      org-confirm-babel-evaluate nil)

;; Create an `org-mode-hook'.
(add-hook 'org-mode-hook
	  (lambda ()
	    (visual-line-mode)))

;; Create a function tht checks if the point is inside a
;; src block and if the language is not found, insert 4
;; spaces literally when pressing <TAB>.
(add-hook 'org-tab-first-hook
	  (lambda ()
	    (when (org-in-src-block-p t)
	      (let* ((elt (org-element-at-point))
		     (lang (intern (org-element-property :language elt)))
		     (langs org-babel-load-languages))
		(unless (alist-get lang langs)
		  (insert (make-string 4 ?\s)))))))

;; Remove `Validate XHTML 1.0' message from HTML export.
(setq org-export-html-validation-link nil
      org-html-validation-link nil)

;; Configure keywords in the TODO -> DONE sequence.
(setq org-todo-keywords '((sequence "TODO" "START" "WAIT" "DONE")))

;; Don't use native image sizes in previews.
(setq org-image-actual-width nil)

;; Configure `org-modern'.
(setq org-modern-star 'replace)

;; Configure styling for `org-modern'.
(setq org-auto-align-tags nil
      org-tags-column 0
      org-catch-invisible-edits 'show-and-error
      org-special-ctrl-a/e t
      org-insert-heading-respect-content t
      org-hide-emphasis-markers t
      org-pretty-entities t
      org-agenda-tag-column 0
      org-elipsis "...")

;; Enable globally.
(with-eval-after-load 'org (global-org-modern-mode))

;; Configure `org-modern-indent'.
(add-to-list 'load-path (expand-file-name "~/.local/share/org-modern-indent/"))
(require 'org-modern-indent)
(add-hook 'org-mode-hook #'org-modern-indent-mode 90)

;; Add custom keybindings.
(dotfiles/leader
  "o" '(:ignore t :which-key "Org")
  "oe" '(org-export-dispatch :which-key "Export")
  "ot" '(org-babel-tangle :which-key "Tangle")
  "oi" '(org-toggle-inline-images :which-key "Images")
  "of" '(:ignore t :which-key "Footnotes")
  "ofn" '(org-footnote-normalize :which-key "Normalize"))

;;;;;;;;;;;;;;;;;;
;;;; ORG ROAM ;;;;
;;;;;;;;;;;;;;;;;;

(require 'org-roam)
(require 'ucs-normalize)

;; Silence migration warnings.
(setq org-roam-v2-ack t)

;; Enable `visual-line-mode' in `org-roam' buffers.
(add-hook 'org-roam-mode-hook
	  (lambda ()
	    (visual-line-mode +1)))

;; Configure `org-roam'.
(setq org-roam-completion-everywhere t
      org-roam-directory (expand-file-name "~/Documents")
      org-roam-dailies-directory (concat org-roam-directory "/daily")
      org-roam-capture-templates '()
      org-roam-dailies-capture-templates '())

;; Override the default slug method.
(cl-defmethod org-roam-node-slug ((node org-roam-node))
  (let ((title (org-roam-node-title node))
        (slug-trim-chars '(768 ; U+0300 COMBINING GRAVE ACCENT
                           769 ; U+0301 COMBINING ACUTE ACCENT
                           770 ; U+0302 COMBINING CIRCUMFLEX ACCENT
                           771 ; U+0303 COMBINING TILDE
                           772 ; U+0304 COMBINING MACRON
                           774 ; U+0306 COMBINING BREVE
                           775 ; U+0307 COMBINING DOT ABOVE
                           776 ; U+0308 COMBINING DIAERESIS
                           777 ; U+0309 COMBINING HOOK ABOVE
                           778 ; U+030A COMBINING RING ABOVE
                           780 ; U+030C COMBINING CARON
                           795 ; U+031B COMBINING HORN
                           803 ; U+0323 COMBINING DOT BELOW
                           804 ; U+0324 COMBINING DIAERESIS BELOW
                           805 ; U+0325 COMBINING RING BELOW
                           807 ; U+0327 COMBINING CEDILLA
                           813 ; U+032D COMBINING CIRCUMFLEX ACCENT BELOW
                           814 ; U+032E COMBINING BREVE BELOW
                           816 ; U+0330 COMBINING TILDE BELOW
                           817 ; U+0331 COMBINING MACRON BELOW
                           )))
    (cl-flet* ((nonspacing-mark-p (char)
				  (memq char slug-trim-chars))
	       (strip-nonspacing-marks (s)
				       (ucs-normalize-NFC-string
					(apply #'string (seq-remove #'nonspacing-mark-p
								    (ucs-normalize-NFD-string s)))))
	       (cl-replace (title pair)
			   (replace-regexp-in-string (car pair) (cdr pair) title)))
      (let* ((pairs `(("[^[:alnum:][:digit:]]" . "-")  
		      ("--*" . "-")  
		      ("^-" . "")  
		      ("-$" . "")))
	     (slug (-reduce-from #'cl-replace (strip-nonspacing-marks title) pairs)))
	(downcase slug)))))

;; Configure capture templates.
;; Standard document.
(add-to-list 'org-roam-capture-templates
  '("d" "Default" plain "%?"
    :target (file+head "${slug}.org"
"
#+TITLE: ${title}
"
)
    :unnarrowed t))

;; Daily notes.
(add-to-list 'org-roam-dailies-capture-templates
  '("d" "Default" entry "* %?"
    :target (file+head "%<%Y-%m-%d>.org"
"
#+TITLE: %<%Y-%m-%d>
")))

;; Keybindings for `org-roam'.
;; Insert link with <SPC> o r i.
;; Find file with <SPC> o r f.
;; Capture with <SPC> o r c.
;; Get / Create with <SPC> o r g.
;; Toggle buffer with <SPC> o r b.
(dotfiles/leader
  "or"  '(:ignore t :which-key "Roam")
  "ori" '(org-roam-node-insert :which-key "Insert")
  "orf" '(org-roam-node-find :which-key "Find")
  "orc" '(org-roam-capture :which-key "Capture")
  "org" '(org-id-get-create :which-key "Get/Create")
  "orb" '(org-roam-buffer-toggle :which-key "Buffer"))

;; Keybindings for `org-roam-dailies'.
;; Find date with <SPC> o r d d.
;; Find today with <SPC> o r d t.
;; Find tomorrow with <SPC> o r d m.
;; Find yesterday with <SPC> o r d y.
(dotfiles/leader
  "ord" '(:ignore t :which-key "Dailies")
  "ordd" '(org-roam-dailies-goto-date :which-key "Date")
  "ordt" '(org-roam-dailies-goto-today :which-key "Today")
  "ordm" '(org-roam-dailies-goto-tomorrow :which-key "Tomorrow")
  "ordy" '(org-roam-dailies-goto-yesterday :which-key "Yesterday"))

;; Run the setup command.
(org-roam-setup)

;; Configure `org-roam-ui'.
(setq org-roam-ui-follow t
      org-roam-ui-sync-theme t
      org-roam-ui-open-on-start t
      org-roam-ui-update-on-save t
      org-roam-ui-browser-function #'browse-url-firefox)

;; Keybindings for `org-roam-ui'.
(dotfiles/leader
  "oru" '(:ignore t :which-key "UI")
  "oruu" '(org-roam-ui-mode :which-key "Toggle UI")
  "orut" '(org-roam-ui-sync-theme :which-key "Sync Theme"))

;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;LANGUAGE SERVERS ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Configure `eglot' globals.
;; See https://github.com/joaotavora/eglot/issues/574
(defun dotfiles/eglot-organize-imports ()
  (call-interactively 'eglot-code-action-organize-imports))

;; Enable eglot with <SPC> l l.
;; Rename symbols with <SPC> l r.
;; Format buffers with <SPC> l f.
(dotfiles/leader
  "l" '(:ignore t :which-key "Eglot")
  "ll" '(eglot :which-key "Eglot")
  "lr" '(eglot-rename :which-key "Rename")
  "lf" '(eglot-format :which-key "Format"))

;;;;;;;;;;;;;;;;;;;;;;;
;;;; LANGUAGE: NIX ;;;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Configure `nix-mode' and `nix-ts-mode'.
(add-hook 'nix-mode-hook 'eglot-ensure)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '((nix-mode nix-ts-mode) . ("nil"))))

;; Configure `alejandra' as the nix formatter.
(setq eglot-workspace-configuration '(:nix (:formattingProvider "alejandra")))

;; Configure a custom `before-save-hook'.
(defun dotfiles/nix-hook ()
  (add-hook 'before-save-hook 'eglot-format-buffer)
  (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

(add-hook 'nix-mode-hook #'dotfiles/nix-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; LANGUAGE: DOCKER ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add the `docker-langserver' to `eglot'.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '((dockerfile-mode dockerfile-ts-mode) . ("docker-langserver" "--stdio"))))

;; Configure a custom `before-save-hook'.
(defun dotfiles/docker-hook ()
  (add-hook 'before-save-hook 'eglot-format-buffer)
  (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

(add-hook 'dockerfile-mode-hook 'eglot-ensure)
(add-hook 'dockerfile-mode-hook #'dotfiles/docker-hook)

;; Open `docker' with <SPC> n d.
(dotfiles/leader
  "n" '(:ignore t :which-key "Containers")
  "nd" '(docker :which-key "Docker"))

;;;;;;;;;;;;;;;;;;;;;;;;
;;;; LANGUAGE: HTML ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Add the `vscode-html-language-server' to `eglot'.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '(html-mode . ("vscode-html-language-server" "--stdio"))))

;; Configure a custom `before-save-hook'.
(defun dotfiles/html-hook ()
  (add-hook 'before-save-hook 'eglot-format-buffer))

(add-hook 'mhtml-mode-hook 'eglot-ensure)
(add-hook 'mhtml-mode-hook #'dotfiles/html-hook)

;;;;;;;;;;;;;;;;;;;;;;;;
;;;; LANGUAGE: YAML ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Add the `yaml-language-server' to `eglot'.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '((yaml-mode yaml-ts-mode) . ("yaml-language-server" "--stdio"))))

;; Configure a custom `before-save-hook'.
(defun dotfiles/yaml-hook ()
  (add-hook 'before-save-hook 'eglot-format-buffer)
  (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

(add-hook 'yaml-mode-hook 'eglot-ensure)
(add-hook 'yaml-mode-hook #'dotfiles/yaml-hook)

;;;;;;;;;;;;;;;;;;;;;;;
;;;; LANGUGAE: LUA ;;;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Add the `lua-language-server' to `eglot'.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '((lua-mode) . ("lua-language-server" "--stdio"))))

;; Configure a custom `before-save-hook'.
(defun dotfiles/lua-hook ()
  (add-hook 'before-save-hook 'eglot-format-buffer)
  (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

(add-hook 'lua-mode-hook 'eglot-ensure)
(add-hook 'lua-mode-hook #'dotfiles/lua-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; LANGUAGE: GOLANG ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Add the `gopls' language server to `eglot'.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '((go-mode go-ts-mode) . ("gopls"))))

;; Configure a custom `before-save-hook'.
(defun dotfiles/go-hook ()
  (add-hook 'before-save-hook 'eglot-format-buffer)
  (add-hook 'before-save-hook #'dotfiles/eglot-organize-imports nil t))

(add-hook 'go-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook #'dotfiles/go-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; LANGUAGE: GDSCRIPT ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'gdscript-mode 'eglot-ensure)
