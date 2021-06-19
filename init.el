(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Package Management
;; -----------------------------------------------------------------
(require 'init-packages)

;; auto update file
(global-auto-revert-mode t )


;; redefined key
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)


;; 设置默认 Org Agenda 文件目录
(setq org-agenda-files '("~/org"))

;; 设置 org-agenda 打开快捷键
(global-set-key (kbd "C-c a") 'org-agenda)

;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
;(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-h f") 'counsel-describe-function)
(global-set-key (kbd "C-h v") 'counsel-describe-variable)
;;(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
;;(global-set-key (kbd "<f1> l") 'counsel-find-library)
;;(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;;(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;;(global-set-key (kbd "C-c g") 'counsel-git)
;;(global-set-key (kbd "C-c j") 'counsel-git-grep)
;;(global-set-key (kbd "C-c k") 'counsel-ag)
;;(global-set-key (kbd "C-x l") 'counsel-locate)
;;(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;;(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

;;editor style
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; (electric-indent-mode 1)

;; close startup UI
(setq inhibit-splash-screen t)

;; line number
(global-linum-mode t)

;;abbrev
(setq-default abbrev-mode t)
(define-abbrev-table 'global-abbrev-table '(
					    ;; Shifu
					    ("blp" "brodyliao/packages")
					    ;; Tudi
					    ("8lxy" "lixinyang")
					    ))
;; custom function
(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f2>") 'open-my-init-file)



;; set cursor
(setq-default cursor-type 'bar)

;; remove back up
(setq make-backup-files nil)
(setq auto-save-default nil)

;; org
(require 'org)
(setq org-src-fontify-natively t)

;; recentf
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; selection mode, can replace word
(delete-selection-mode t)

;; open width full screen
(setq initial-frame-alist (quote ((fullscreen . maximized))))

;; show match parents
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

;; highlight current line
(global-hl-line-mode t )













