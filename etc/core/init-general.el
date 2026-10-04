;;; init-general.el --- Leader key 前缀定义 -*- lexical-binding: t -*-
(use-package general
  :ensure t
  :config
  (general-evil-setup t)

  (general-create-definer bl/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer bl/ctrl-c-keys
    :prefix "C-c"))


(provide 'init-general)