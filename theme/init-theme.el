;;  (use-package doom-themes
;;  :ensure t
;;  :config
;;  ;; Global settings (defaults)
;;  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;        doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;  (load-theme 'doom-one t)

;;  ;; Enable flashing mode-line on errors
;;  (doom-themes-visual-bell-config)
;;  ;; Enable custom neotree theme (all-the-icons must be installed!)
;;  (doom-themes-neotree-config)
;;  ;; or for treemacs users
;;  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
;;  (doom-themes-treemacs-config)
;;  ;; Corrects (and improves) org-mode's native fontification.
;;  (doom-themes-org-config))
;;  (use-package smart-mode-line
;;  :init
;;  (setq sml/no-confirm-load-theme t
;;  sml/theme 'respectful
;;  sml/mode-width 'right
;;  sml/name-width 60)
;;    (sml/setup))

;; (use-package kaolin-themes
;;   :config
;;   (load-theme 'kaolin-dark t)
;;   (kaolin-treemacs-theme))


  ;; (use-package zenburn-theme
  ;;   :ensure t
  ;;   :config (load-theme 'zenburn t))

;; (load-theme 'leuven t)
(use-package dracula-theme
  :ensure t)
(load-theme 'dracula t)

;;gruvbox-dark-medium, gruvbox-dark-soft, gruvbox-dark-hard,
  ;; (use-package gruvbox-theme 
  ;;   :ensure t
  ;;   :config
  ;;   (load-theme 'gruvbox t))

  ;;  (use-package monokai-theme
  ;;               :config
  ;;               (load-theme 'monokai t))


(setq rm-excluded-modes
(mapconcat
'identity
; These names must start with a space!
'(" GitGutter" " MRev" " company"
" Helm" " Undo-Tree" " Projectile.*" " Z" " Ind"
" Org-Agenda.*" " ElDoc" " SP/s" " cider.*")
"\\|"))


(provide 'init-theme)
