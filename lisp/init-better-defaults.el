(setq ring-bell-function 'ignore)

;; auto update file
(global-auto-revert-mode t )

;; line number
(global-linum-mode t)


;; selection mode, can replace word
(delete-selection-mode t) 

;;abbrev
(setq-default abbrev-mode t)
(define-abbrev-table 'global-abbrev-table '(
					    ;; Shifu
					    ("blp" "brodyliao/packages")
					    ;; Tudi
					    ("8lxy" "lixinyang")
					    ))

;; remove back up
(setq make-backup-files nil)
(setq auto-save-default nil)

;; recentf
(recentf-mode 1)
(setq recentf-max-menu-item 25)

;; show match parents
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

(provide 'init-better-defaults)
