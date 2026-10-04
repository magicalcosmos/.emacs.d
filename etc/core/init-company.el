
;;; init-company.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(use-package company
    :defer 0.1
    :config
    (global-company-mode t)
    (setq-default
        company-idle-delay 0.05
        company-require-match nil
        company-minimum-prefix-length 0

        ;; get only preview
        company-frontends '(company-preview-frontend)
        ;; also get a drop down
        ;; company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
        ))
;; With use-package:
;; (use-package company-box
;;   :ensure t
;;   :hook (company-mode . company-box-mode))

;; prescient.el is a library which sorts and filters lists of candidates, such as appear when you use a package like Ivy or Company. Extension packages such as ivy-prescient.el and company-prescient.el adapt the library for usage with various frameworks.
(use-package company-prescient
  :ensure t
  :after company
  :config
  (company-prescient-mode))

(setq tab-always-indent 'complete)

(provide 'init-company)
