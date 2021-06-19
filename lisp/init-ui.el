;;editor style
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; (electric-indent-mode 1)

;; close startup UI
(setq inhibit-splash-screen t)

;; set cursor
(setq-default cursor-type 'bar)

;; open width full screen
(setq initial-frame-alist (quote ((fullscreen . maximized)))) 


;; highlight current line
(global-hl-line-mode t )

(provide 'init-ui)
