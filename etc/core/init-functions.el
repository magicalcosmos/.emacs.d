;;; init-functions.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

;; 仅在 Linux 下探测 Termux，避免 Windows/macOS 上调用不存在的 uname
(setq bl/is-termux
      (and (eq system-type 'gnu/linux)
           (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a")))))

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
  "Save the current buffer and kill it.

Bound to the Vim ex command `:wq' (see init-evil.el).

With-editor buffers (magit 的提交/变基缓冲区等) need special handling:
they are the \$EDITOR of an external process, so the buffer must be
finished via `with-editor-finish' rather than killed -- killing it
trips `with-editor-kill-buffer-noop', which errors out with
\"Don't kill this buffer ...\" and leaves the commit unfinished.
`with-editor-mode-map' remaps `evil-save-modified-and-close' to
`with-editor-finish', but a custom ex command calling the functions
directly bypasses that remap."
  (interactive)
  (if (bound-and-true-p with-editor-mode)
      ;; with-editor-finish 的 FORCE 参数没有 optional，需显式传 nil
      (with-editor-finish nil)
    (save-buffer)
    (kill-this-buffer)))


(provide 'init-functions)