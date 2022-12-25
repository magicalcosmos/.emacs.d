(use-package auto-package-update
   :ensure t
   :config
   (setq auto-package-update-delete-old-versions t
         auto-package-update-interval 4
         auto-package-update-prompt-before-update t
         auto-package-update-show-preview t)
   (auto-package-update-maybe))

;; (auto-package-update-at-time "03:00")

(provide 'init-auto-package-update)