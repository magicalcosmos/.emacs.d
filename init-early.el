;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(require 'cc-mode)

(require 'init-const)

(require 'init-funcs)

(require 'init-basic)

(require 'init-packages)

(require 'init-general)

;; config as below is from https://github.com/emacs-lsp/lsp-mode/blob/master/docs/tutorials/reactjs-tutorial.md
(require 'init-lsp-mode)
(require 'init-lsp-treemacs)

(require 'init-syntaxcheck)

(require 'init-yasnippet)
;; (require 'init-helm-lsp)
;; (require 'init-helm-xref)
;; (require 'init-hydra)
(require 'init-flycheck)

(require 'init-company)
;; (require 'init-avy)
(require 'init-which-key)
;; (require 'init-dap-mode)
;; (require 'init-json-mode)
;; (require 'init-auto-package-update)
;; ;; new config
;; (require 'color-rg)
;; (require 'init-js-doc)

;; (require 'init-rg)



(require 'init-icons)

  ;;(require 'init-persp-projectile)
;; (require 'init-projectile)

(require 'init-theme)
;; (require 'init-dashboard)


(require 'init-undo-tree)
(require 'init-evil)
(require 'init-magit)

;;(require 'init-lsp)

(require 'init-treemacs)
;; (require 'init-window)
(require 'init-ace-window)
;; (require 'init-drag-stuff)


;; (require 'init-shell)

;; (require 'init-separedit)

(require 'init-web)

;; (require 'init-swiper-ivy-counsel)



;;(require 'init-org)

;; (require 'init-rust)

;; (require 'init-end-executed)

;; (require 'init-corfu)

;; (require 'init-fzf)
;; (require 'init-vterm)

(require 'init-dired)
;; (require 'init-org-roam)

(require 'init-vertico)

(require 'init-orderless)

(require 'init-embark)

(require 'init-consult)

;; (require 'init-lsp-volar)

(require 'init-keybindings)

;; (require 'init-quelpa)


