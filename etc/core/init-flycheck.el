(use-package flycheck
  :ensure t
  :init
  (setq flycheck-emacs-lisp-load-path 'inherit)
  :config
  (global-flycheck-mode t))


(provide 'init-flycheck)