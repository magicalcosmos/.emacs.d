
;;; init-basic.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(setq gc-cons-threshold most-positive-fixnum)



(add-hook 'emacs-startup-hook
          (lambda ()
            "Recover GC values after startup."
            (setq gc-cons-threshold 100000000
                  gc-cons-percentage 0.1)))
; gain the emacs default is too low 4k considering that the some of the language server responses are in 800k - 3M range                 
(setq read-process-output-max (* 1024 1024)) ;; 1mb


;; Set frame transparency and maximize windows by default.
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))

;; 最大化, 非沉浸模式
(toggle-frame-maximized)

;; Speed up startup
(setq auto-mode-case-fold nil)

;; 关闭启动画面
(setq inhibit-startup-message t)

;; yes to y, no to n
(fset 'yes-or-no-p 'y-or-n-p)

;; 设置自动加载已修改文件
(global-auto-revert-mode t)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; 设置 Emacs 的缺省工作路径
(setq default-directory "~/")

;; Disable visible scrollbar
(scroll-bar-mode -1)

;; Disable the toolbar
(tool-bar-mode -1)

;; activate line numbering in all buffers/modes
(global-display-line-numbers-mode 1)

;; set type of line numbering (global variable)
(setq display-line-numbers-type 'relative)

;; Activate line numbering in programming modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; 不自动保存 
(setq auto-save-default nil)

;; 不生成备份文件
(setq make-backup-files nil)

;; 不生成 lock 文件
(setq create-lockfiles nil)

(setq-default tab-width 2)

;; Use spaces instead of tabs for indentation
(setq-default indent-tabs-mode nil)

;; user custom config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))


;; set font size
(set-default-coding-systems 'utf-8)

(prefer-coding-system 'utf-8)

(set-terminal-coding-system 'utf-8)

(set-keyboard-coding-system 'utf-8)

(setq default-buffer-file-coding-system 'utf-8)

;; Set font size 180 = 18pt
(set-face-attribute 'default nil :height 160)


(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)

;; 编程模式下，可以折叠代码块                    
(add-hook 'prog-mode-hook #'hs-minor-mode)  

;; ESC Cancels All
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
  
;; 在 Mode line 上显示列号
(column-number-mode t)


;; 错误时的“哔哔”的警告提示音
(setq ring-bell-function 'ignore)

;; 缓解在快速移动时大量代码的语法高亮
(setq redisplay-skip-fontification-on-input t)


(provide 'init-basic)