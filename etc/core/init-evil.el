;;; init-evil.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(use-package evil
  :ensure t
  :init
  (setq evil-want-fine-undo t)
  (setq evil-shift-width 2)
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :config
  (add-hook 'evil-mode-hook 'bl/evil-hook)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-paste-pop-next)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-paste-pop)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (unless bl/is-termux
    ;; Disable arrow keys in normal and visual modes
    (define-key evil-normal-state-map (kbd "<left>") 'bl/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<right>") 'bl/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<down>") 'bl/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<up>") 'bl/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<left>") 'bl/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<right>") 'bl/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<down>") 'bl/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<up>") 'bl/dont-arrow-me-bro))

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(evil-mode 1)

(provide 'init-evil)
