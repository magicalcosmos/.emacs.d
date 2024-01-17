;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(push "~/.emacs" load-path)

(setenv "PATH" (concat "/usr/local/bin:/opt/homebrew/bin:" (getenv "PATH")))
(setq exec-path (append exec-path '("/usr/local/bin" "/opt/homebrew/bin")))

(add-to-list 'load-path "~/.emacs.d/etc/core/")
(add-to-list 'load-path "~/.emacs.d/etc/lisp/")
(add-to-list 'load-path "~/.emacs.d/theme/")



(load-file (expand-file-name "start.el" user-emacs-directory))

(load-file (expand-file-name "init-early.el" user-emacs-directory))

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file 'no-error 'no-message)
