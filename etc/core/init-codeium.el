
;;; init-codeium.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao
;; 安装并配置 Codeium
(use-package codeium
  :straight (:type git :host github :repo "Exafunction/codeium.el")
  :init
  ;; 禁用部分 keybinds 或设置你自己的按键绑定
  (setq use-dialog-box nil) ;; 如果想禁用 Emacs 的图形对话框
  :config
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point))


(provide 'init-codeium)