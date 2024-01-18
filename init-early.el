;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(require 'init-funcs)

(require 'init-basic)

(require 'init-general)

(require 'init-icons)

(require 'init-theme)

(require 'init-ace-window)

(require 'init-vertico)

(require 'init-orderless)

(require 'init-marginalia)

(require 'init-embark)

(require 'init-consult)

(require 'init-lsp-mode)

(require 'init-company)

(require 'init-which-key)

(require 'init-undo-tree)

(require 'init-evil)

(require 'init-magit)

(require 'init-web)

(require 'init-typescript)

(require 'init-keybindings)
