
;;; init-basic.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(setq inhibit-startup-screen t)

;; Speed up startup
(setq auto-mode-case-fold nil)

;; Set frame transparency and maximize windows by default.
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
;; (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
;; (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; (add-to-list 'default-frame-alist '(fullscreen . fullheight))
(toggle-frame-maximized)

;; 设置自动加载已修改文件
(global-auto-revert-mode t)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; 设置 Emacs 的缺省工作路径
(setq default-directory "~/")

;; Newline at end of file
(setq require-final-newline t)

;; 设置选中时编辑直接删除选中值
(delete-selection-mode t)

;; 设置光标样式
(setq-default cursor-type '(bar . 5))

;; 自动补全括号
(electric-pair-mode t)    

;; 编程模式下，光标在括号上时高亮另一个括号                   
(add-hook 'prog-mode-hook #'show-paren-mode) 

;; 在 Mode line 上显示列号
(column-number-mode t)

;; 选中文本后输入文本会替换文本（更符合我们习惯了的其它编辑器的逻辑）                       
(delete-selection-mode t)

;; 编程模式下，可以折叠代码块                    
(add-hook 'prog-mode-hook #'hs-minor-mode)   

;; 图形界面时关闭滚动条
(when (display-graphic-p) (toggle-scroll-bar -1)) 

;; remove cl warning
(setq byte-compile-warnings '(cl-functions))

;; Disable visible scrollbar
(scroll-bar-mode -1)

;; Disable the toolbar
(tool-bar-mode -1)

(show-paren-mode 1)

;; give some breathing room
(set-fringe-mode 10)

;; Diable the menu bar
(menu-bar-mode -1)

;; yes to y, no to n
(fset 'yes-or-no-p 'y-or-n-p)

;; 缓解在快速移动时大量代码的语法高亮
(setq redisplay-skip-fontification-on-input t)

;; set realtive numbers
(display-line-numbers-mode t)

;; set type of line numbering (global variable)
(setq display-line-numbers-type 'relative)

;; activate line numbering in all buffers/modes
(global-display-line-numbers-mode 1)

;; Activate line numbering in programming modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(global-hl-line-mode 1)

(delete-selection-mode t)

;; 错误时的“哔哔”的警告提示音
(setq ring-bell-function 'ignore)

(setq auto-save-default nil)

(setq make-backup-files nil)

(setq create-lockfiles nil)

;; set font size
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; Set font size 180 = 18pt
(set-face-attribute 'default nil :height 140)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

;; (let ((normal-gc-cons-threshold (* 20 1024 1024))
;;       (init-gc-cons-threshold (* 128 1024 1024)))
;;   (setq gc-cons-threshold init-gc-cons-threshold)
;;   (add-hook 'emacs-startup-hook
;;             (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))
(add-hook 'emacs-startup-hook
          (lambda ()
            "Recover GC values after startup."
            (setq gc-cons-threshold 80000000
                  gc-cons-percentage 0.1)))


;; Silence compiler warnings as they can be pretty disruptive
(setq native-comp-async-report-warnings-errors nil)
(setq comp-async-report-warnings-errors nil)
(setq warning-minimum-level :emergency)
(setq large-file-warning-threshold nil)
(setq vc-follow-symlinks t)
(setq ad-redefinition-action 'accept)
(require 'subr-x)


(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)


;; Tab Widths
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)
;; Use spaces instead of tabs for indentation
(setq-default indent-tabs-mode nil)


;; command key to meta for default
;; (when *is-mac*
;;   (setq mac-option-modifier 'meta
;;       mac-command-modifier 'none))
(when *is-mac*
   (setq mac-command-modifier 'meta))


;; 设置平滑滚动
(unless bl/is-termux
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
  (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
  (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
  (setq scroll-step 1) ;; keyboard scroll one line at a time
  (setq use-dialog-box nil)) ;; Disable dialog boxes since they weren't working in Mac OSX


(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :init (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
	      history-length 1000
	      savehist-additional-variables '(mark-ring
					      global-mark-ring
					      search-ring
					      regexp-search-ring
					      extended-command-history)
	      savehist-autosave-interval 300)
  )

(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

(use-package simple
  :ensure nil
  :hook (after-init . size-indication-mode)
  :init
  (progn
    (setq column-number-mode t)
    ))


(provide 'init-basic)