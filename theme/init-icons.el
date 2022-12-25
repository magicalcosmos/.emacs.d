(use-package all-the-icons
:ensure t
:defer 4)

;; (use-package all-the-icons-ivy
;; :ensure t
;;   :after (all-the-icons ivy)
;;   :custom (all-the-icons-ivy-buffer-commands '(ivy-switch-buffer-other-window ivy-switch-buffer))
;;   :config
;;   (add-to-list 'all-the-icons-ivy-file-commands 'counsel-dired-jump)
;;   (add-to-list 'all-the-icons-ivy-file-commands 'counsel-find-library)
;;   (all-the-icons-ivy-setup))


(use-package all-the-icons-dired :ensure t)

(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)


(provide 'init-icons)