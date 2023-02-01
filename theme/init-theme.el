;; (use-package doom-themes)
;; (load-theme 'doom-one 1)

;; (use-package valign
;;   :ensure t
;;   :hook ((markdown-mode org-mode) . valign-mode))

;; (use-package doom-modeline
;;   :ensure t
;;   :custom-face
;; (mode-line ((t (:height 0.9))))
;; (mode-line-inactive ((t (:height 0.9))))
;;   :init
;;   (doom-modeline-mode t))

;; (use-package visual-fill-column
;;   :init
;;   ;; Configure fill width
;; (setq visual-fill-column-width 110
;;       visual-fill-column-center-text t))

(use-package solarized-theme)
(load-theme 'solarized-light t)

(provide 'init-theme)
