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
  :hook ((lsp-mode . yas-minor-mode)))


(provide 'init-yasnippet)