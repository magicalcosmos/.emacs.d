;;; init-embark.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package embark
  :bind
  (
   :map minibuffer-mode-map
   ("H-o" . embark-export)
   )
  )


;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


(use-package wgrep
  :bind
  (
   :map grep-mode-map
   ("C-c C-q" . wgrep-change-to-wgrep-mode)
   )
  )
  
(setq wgrep-auto-save-buffer t)

(eval-after-load
    'consult
  '(eval-after-load
       'embark
     '(progn
	(require 'embark-consult)
	(add-hook
	 'embark-collect-mode-hook
	 #'consult-preview-at-point-mode))))

(define-key minibuffer-local-map (kbd "C-c C-e") 'embark-export-write)


  (provide 'init-embark)