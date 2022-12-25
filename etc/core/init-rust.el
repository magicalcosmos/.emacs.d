(use-package rust-mode
  :mode "\\.rs\\'"
  :init (setq rust-format-on-save t))

(use-package cargo
  :straight t
  :defer t)

(provide 'init-rust)