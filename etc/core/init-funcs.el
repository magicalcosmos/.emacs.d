;;; init-funcs.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(setq bl/is-termux
      (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))

(defun bl/evil-hook ()
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  sauron-mode
                  term-mode))
  (add-to-list 'evil-emacs-state-modes mode)))


(defun bl/dont-arrow-me-bro ()
(interactive)
(message "Arrow keys are Forbidden for evil, you know?"))


(defun bl/save-and-kill-this-buffer ()
  (interactive)
  (save-buffer)
  (kill-this-buffer))


(provide 'init-funcs)