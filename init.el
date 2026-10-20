;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(push "~/.emacs" load-path)

;; 平台相关可执行文件路径（macOS: Homebrew/volta；Windows: Git/Volta，目录存在才加入）
(cond
 ((eq system-type 'darwin)
  (setenv "PATH" (concat "/usr/local/bin:/opt/homebrew/bin:" (getenv "PATH")))
  (setq exec-path (append exec-path '("/usr/local/bin" "/opt/homebrew/bin")))
  ;; volta（Node 版本管理器）的工具路径：typescript-language-server 等
  (let ((volta-bin (expand-file-name "~/.volta/bin")))
    (when (file-directory-p volta-bin)
      (setenv "PATH" (concat volta-bin path-separator (getenv "PATH")))
      (add-to-list 'exec-path volta-bin))))
 ((eq system-type 'windows-nt)
  ;; straight.el 引导、lsp 等需要 git；Volta 提供 node/claude 等
  (dolist (dir (delq nil
                     (list "C:/Program Files/Git/cmd"
                           "D:/Program Files/Git/cmd"
                           (when (getenv "LOCALAPPDATA")
                             (expand-file-name "Volta/bin" (getenv "LOCALAPPDATA")))
                           (expand-file-name "~/.volta/bin"))))
    (when (file-directory-p dir)
      (add-to-list 'exec-path dir)
      (setenv "PATH" (concat (getenv "PATH") path-separator dir))))))

(add-to-list 'load-path "~/.emacs.d/etc/core/")
(add-to-list 'load-path "~/.emacs.d/etc/lisp/")
(add-to-list 'load-path "~/.emacs.d/theme/")



(load-file (expand-file-name "start.el" user-emacs-directory))

(load-file (expand-file-name "init-early.el" user-emacs-directory))

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file 'no-error 'no-message)
