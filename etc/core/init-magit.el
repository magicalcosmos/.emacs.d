;;; magit -- Echo "magit"
;;; Commentary:
;;; Code:

(use-package git-gutter+
  :ensure t
  :config
  (progn
    (global-git-gutter+-mode)))

(use-package git-timemachine
  :ensure t
  :defer 10)

(use-package magit
  :ensure t
  :bind ("C-M-;" . magit-status)
  :config
  (setq magit-diff-refine-hunk (quote all))
  :hook ((magit-post-commit-hook) . 'git-gutter:update-all-windows))

;; A git blame plugin for emacs inspired by VS Code’s GitLens plugin and Vim plugin
(use-package blamer
  :ensure t
  :bind (("s-i" . blamer-show-commit-info)
         ("C-c i" . blamer-show-posframe-commit-info))
  :defer 20
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                    :background nil
                    :height 140
                    :italic t)))
  :config
  (global-blamer-mode 1))

(provide 'init-magit)
