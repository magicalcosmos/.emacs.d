(use-package doom-themes)
(load-theme 'doom-one 1)

(use-package doom-modeline
  :ensure t
  :custom-face
(mode-line ((t (:height 0.9))))
(mode-line-inactive ((t (:height 0.9))))
  :init
  (doom-modeline-mode t))

(provide 'init-theme)
