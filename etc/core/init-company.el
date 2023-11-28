
;;; init-company.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(use-package company
  :after lsp-mode
  :init
  (global-company-mode t)
  :bind (:map company-active-map
	      ("C-n" . 'company-select-next)
	      ("C-p" . 'company-select-previous))
  :config
    ;; Number the candidates (use M-1, M-2 etc to select completions).
    (setq company-show-numbers t)
    (setq company-minimum-prefix-length 1)
    ;; Trigger completion immediately.
    (setq company-idle-delay 0)
  :hook (lsp-mode . company-mode))

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode))

;; (use-package company-tabnine :ensure t)
;; (add-to-list 'company-backends #'company-tabnine)

;; (setq tab-always-indent 'complete)


(provide 'init-company)