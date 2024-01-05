
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
    ;; Trigger completion immediately.
    (setq company-minimum-prefix-length 3) ; 只需敲 1 个字母就开始进行自动补全
    (setq company-tooltip-align-annotations t)
    (setq company-idle-delay 0.0)
    (setq company-selection-wrap-around t)
    (setq company-transformers '(company-sort-by-occurrence))) ; 根据选择的频率进行排序，读者如果不喜欢可以去掉)

;; 图标
;; (use-package company-box
;;   :if window-system
;;   :hook (company-mode . company-box-mode))

;; prescient.el is a library which sorts and filters lists of candidates, such as appear when you use a package like Ivy or Company. Extension packages such as ivy-prescient.el and company-prescient.el adapt the library for usage with various frameworks.
(use-package company-prescient
  :after company
  :config
  (company-prescient-mode))


(use-package company-tabnine)
(add-to-list 'company-backends #'company-tabnine)

;; workaround for company-transformers
(setq company-tabnine--disable-next-transform nil)
(defun my-company--transform-candidates (func &rest args)
  (if (not company-tabnine--disable-next-transform)
      (apply func args)
    (setq company-tabnine--disable-next-transform nil)
    (car args)))

(defun my-company-tabnine (func &rest args)
  (when (eq (car args) 'candidates)
    (setq company-tabnine--disable-next-transform t))
  (apply func args))

(advice-add #'company--transform-candidates :around #'my-company--transform-candidates)
(advice-add #'company-tabnine :around #'my-company-tabnine)


(setq tab-always-indent 'complete)


(provide 'init-company)

