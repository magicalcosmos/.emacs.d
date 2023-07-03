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

(require 'init-yasnippet)

;; config as below is from https://github.com/emacs-lsp/lsp-mode/blob/master/docs/tutorials/reactjs-tutorial.md
(require 'init-lsp-mode)

;; (require 'init-lsp-bridge)
(require 'init-lsp-treemacs)

(require 'init-syntaxcheck)

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
(require 'init-js-doc)

;; (require 'init-rg)



(require 'init-icons)

;; (require 'init-persp-projectile)
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

;; (require 'init-dired)
;; (require 'init-org-roam)

;; (require 'init-popwin)

(require 'init-vertico)

(require 'init-orderless)

(require 'init-embark)

(require 'init-consult)

;; (require 'init-lsp-volar)

(require 'init-keybindings)

;; (require 'init-quelpa)
(require 'init-ranger)

(require 'init-dart)

;; (require 'copilot)
;; (add-hook 'prog-mode-hook 'copilot-mode)

;; (with-eval-after-load 'company
;;   ;; disable inline previews
;;   (delq 'company-preview-if-just-one-frontend company-frontends))
  
;; (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
;; (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

(when (and (display-graphic-p) (= (display-screens) 3))
  (make-frame)
  (set-frame-position (selected-frame) 1440 2560))