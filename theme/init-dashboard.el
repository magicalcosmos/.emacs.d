;; (use-package
;;   page-break-lines
;;   :ensure t)

;; (page-break-lines-mode)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)

(setq dashboard-items '(
                        ;;(recents  . 5)
                        ;;(bookmarks . 5)
                        (agenda . 5)
                        (projects . 5)
                        ;;(registers . 5)
                        ))
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)
(setq dashboard-set-init-info t)
;;(setq dashboard-startup-banner "~/.emacs.d/emacs-logo.png")
;;(setq dashboard-projects-switch-function 'counsel-projectile-switch-project)
(setq dashboard-projects-switch-function 'projectile-switch-project-by-name)
;;(setq projectile-switch-project-action 'projectile-switch-project-by-name)
  ;;(setq dashboard-projects-switch-function 'projectile-persp-switch-project)
  (setq dashboard-week-agenda t)
  ;;(setq dashboard-filter-agenda-entry dashboard-no-filter-agenda)
  ;;(setq dashboard-match-agenda-entry "~/Sync/orgfiles";; Content is not centered by default. To center, set
  (setq dashboard-center-content t)
  ;; To disable shortcut "jump" indicators for each section, set
  (setq dashboard-show-shortcuts nil)
  (dashboard-modify-heading-icons '((recents . "file-text")
                                              (bookmarks . "book")))
  (setq dashboard-set-navigator t)
  (setq dashboard-set-footer t)
  (setq dashboard-org-agenda-categories '("Tasks" "Appointments"))
  (setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)

  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*"))))

(provide 'init-dashboard)