
;;; init-pdf-tools.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(use-package pdf-tools
:defer t
:commands (pdf-view-mode pdf-tools-install)
:mode("\\.[pP][dD][fF]\\'" . pdf-view-mode)
:magic("%PDF" . pdf-view-mode)
:config
  (pdf-tools-install)  ; Standard activation command
  (pdf-loader-install) ; On demand loading, leads to faster startup time
  (define-pdf-cache-function pagelabels)
  :hook ((pdf-view-mode-hook . (lambda()(display-line-numbers-mode -1)))
        (pdf-view-mode-hook . pdf-tools-enable-minor-nodes)))


(provide 'init-pdf-tools)