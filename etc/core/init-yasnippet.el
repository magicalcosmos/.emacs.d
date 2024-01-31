;;; init-yasnippet.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao
(use-package yasnippet
  :ensure t
  :hook ((text-mode
          prog-mode
          conf-mode
          web-mode
          snippet-mode) . yas-minor-mode-on)
  :init
  (setq yas-snippet-dir "~/.emacs.d/snippets"))

(require 'yasnippet)
(yas-global-mode 1)

(provide 'init-yasnippet)
