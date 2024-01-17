
;;; init-basic.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(setq gc-cons-threshold most-positive-fixnum)

(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000)))

;; Set frame transparency and maximize windows by default.
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))

;; 最大化, 非沉浸模式
(toggle-frame-maximized)

;; Speed up startup
(setq auto-mode-case-fold nil)

;; 关闭启动画面
(setq inhibit-startup-message t)

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


;; user custom config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))


(provide 'init-basic)