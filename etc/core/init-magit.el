
(use-package git-gutter+
  :ensure t
  :config
  (progn
    (global-git-gutter+-mode)))

(use-package git-timemachine
  :defer 10)

(use-package magit
  :ensure t
  :bind ("C-M-;" . magit-status)
  :config
  (setq magit-diff-refine-hunk (quote all))
  :hook ((magit-post-commit-hook) . 'git-gutter:update-all-windows))


(bl/leader-key-def
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gm"   '(:ignore t :which-key "merge")
  "gmm"  'magit-merge
  "gme"  'magit-merge-editmsg
  "gmn"  'magit-merge-nocommit
  "gmi"  'magit-merge-into
  "gms"  'magit-merge-squash
  "gmp"  'magit-merge-preview
  "gr"  'magit-rebase)

;; A git blame plugin for emacs inspired by VS Code’s GitLens plugin and Vim plugin
(use-package blamer
  :ensure t
  :bind (("s-i" . blamer-show-commit-info))
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
