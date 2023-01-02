;;; init-undo-tree.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(use-package undo-tree
  :ensure t
  :config
  (progn
    (global-undo-tree-mode 1)
    (setq undo-tree-auto-save-history nil)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)
    (setq undo-tree-history-directory-alist '(("." . "~/undo-tree")))
    ))

(provide 'init-undo-tree)
