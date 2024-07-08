;;; init-marginalia.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:
;; 在vertico中的minibuffer显示按键具体描述
;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao



(use-package marginalia
  :ensure t
  ;; :custom
  ;; (marginalia-max-relative-age 0)
  ;; (marginalia-align 'right)
  :init
  (marginalia-mode t))


  (provide 'init-marginalia)