
;;; init-company.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(use-package company
  :ensure t
  :after lsp-mode
  :init
  (global-company-mode t)
  :bind (:map company-active-map
	      ("C-n" . 'company-select-next)
	      ("C-p" . 'company-select-previous))
  :config
    ;; Number the candidates (use M-1, M-2 etc to select completions).
    (setq company-show-numbers t)
    ;; Trigger completion immediately.
    (setq company-minimum-prefix-length 1) ; 只需敲 1 个字母就开始进行自动补全
    (setq company-tooltip-align-annotations t)
    (setq company-idle-delay 0.0)
    (setq company-selection-wrap-around t)
    (setq company-transformers '(company-sort-by-occurrence))) ; 根据选择的频率进行排序，读者如果不喜欢可以去掉)

;; With use-package:
(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))


(setq tab-always-indent 'complete)

(provide 'init-company)

