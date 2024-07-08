;;; init-early.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(require 'init-functions)

(require 'init-basic)

(require 'init-company)

(require 'init-codeium)

(require 'init-corfu)

(require 'init-evil)

(require 'init-general)

(require 'init-vertico)

(require 'init-orderless)

(require 'init-marginalia)

(require 'init-consult)

(require 'init-embark)

(require 'init-undo-tree)

(require 'init-ace-window)

(require 'init-treemacs)

(require 'init-web)

(require 'init-lsp-mode)