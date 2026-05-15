;;;;;;;;;;;;;;;;;;;;
;;;; UI CLEANUP ;;;;
;;;;;;;;;;;;;;;;;;;;

;; Disable unwanted UI elements.
(tooltip-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Disable startup screen.
(setq inhibit-startup-screen t)

;; Disable backup files.
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

;; Improved prompts:
;; Use 'y' and 'n' instead of 'yes' and 'no'.
(setq use-short-answers t)

;; Fix scrolling behaviour.
(setq scroll-conservatively 101)

;; Fix mouse-wheel scrolling behaviour.
(setq mouse-wheel-follow-mouse t
      mouse-wheel-progressive-speed t
      mouse-wheel-scroll-amount '(3 ((shift) . 3)))

;; Stop generating native comp logs.
(setq native-comp-async-report-warnings-errors nil)
