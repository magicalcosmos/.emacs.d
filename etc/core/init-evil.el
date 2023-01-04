;;; init-evil.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

;; (use-package evil
;;   :init
;;   (setq evil-want-fine-undo t)
;;   (setq evil-shift-width 2)
;;   (setq evil-want-keybinding nil)
;;   (setq evil-want-integration t)
;;   (setq evil-want-C-u-scroll t)
;;   (setq evil-want-C-i-jump nil)
;;   (setq evil-respect-visual-line-mode t)
;;   (setq evil-undo-system 'undo-tree)
;;   :config
;;   (add-hook 'evil-mode-hook 'bl/evil-hook)
;;   (evil-mode 1)
;;   (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
;;   (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

;;   ;; Use visual line motions even outside of visual-line-mode buffers
;;   (evil-global-set-key 'motion "j" 'evil-next-visual-line)
;;   (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

;;   (unless bl/is-termux
;;     ;; Disable arrow keys in normal and visual modes
;;     (define-key evil-normal-state-map (kbd "<left>") 'bl/dont-arrow-me-bro)
;;     (define-key evil-normal-state-map (kbd "<right>") 'bl/dont-arrow-me-bro)
;;     (define-key evil-normal-state-map (kbd "<down>") 'bl/dont-arrow-me-bro)
;;     (define-key evil-normal-state-map (kbd "<up>") 'bl/dont-arrow-me-bro)
;;     (evil-global-set-key 'motion (kbd "<left>") 'bl/dont-arrow-me-bro)
;;     (evil-global-set-key 'motion (kbd "<right>") 'bl/dont-arrow-me-bro)
;;     (evil-global-set-key 'motion (kbd "<down>") 'bl/dont-arrow-me-bro)
;;     (evil-global-set-key 'motion (kbd "<up>") 'bl/dont-arrow-me-bro))

;;   (evil-set-initial-state 'messages-buffer-mode 'normal)
;;   (evil-set-initial-state 'dashboard-mode 'normal))

;; (use-package evil-nerd-commenter
;;   :ensure t)

;; (use-package evil-collection
;;   :after evil
;;   :init
;;   (setq evil-collection-company-use-tng nil)  ;; Is this a bug in evil-collection?
;;   :custom
;;   (evil-collection-outline-bind-tab-p nil)
;;   :config
;;   (setq evil-collection-mode-list
;;         (remove 'lispy evil-collection-mode-list))
;;   (evil-collection-init))
(require 'init-funcs)



(use-package evil
  :ensure t
  :init
  (setq evil-want-fine-undo t)
  (setq-default evil-shift-width 2)
  (setq-default tab-width 2)
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  (evil-mode)

  ;; https://emacs.stackexchange.com/questions/46371/how-can-i-get-ret-to-follow-org-mode-links-when-using-evil-mode
  (with-eval-after-load 'evil-maps
    (define-key evil-motion-state-map (kbd "RET") nil))

  :config
  (progn
    (setcdr evil-insert-state-map nil)
    (define-key evil-insert-state-map [escape] 'evil-normal-state)

    (setq-default evil-ex-search-persistent-highlight nil)



    (define-key evil-visual-state-map "p" 'evil-paste-after)
    (define-key evil-insert-state-map (kbd "C-r") 'evil-paste-from-register)
    (define-key evil-insert-state-map (kbd "C-;") 'flyspell-correct-previous)


    ;;mimic "nzz" behaviou in vim
    (defadvice evil-search-next (after advice-for-evil-search-next activate)
      (evil-scroll-line-to-center (line-number-at-pos)))

    (defadvice evil-search-previous (after advice-for-evil-search-previous activate)
      (evil-scroll-line-to-center (line-number-at-pos)))


    (defun my-evil-yank ()
      (interactive)
      (save-excursion
        (call-interactively 'evil-yank))
      (backward-char))

    (define-key evil-visual-state-map (kbd "y") 'my-evil-yank)

    (define-key evil-normal-state-map
      (kbd "Y") 'zilongshanren/yank-to-end-of-line)

    (define-key evil-normal-state-map (kbd "[ SPC") (lambda () (interactive) (evil-insert-newline-above) (forward-line)))
    (define-key evil-normal-state-map (kbd "] SPC") (lambda () (interactive) (evil-insert-newline-below) (forward-line -1)))

    (define-key evil-normal-state-map (kbd "g[")
      (lambda () (interactive) (beginning-of-defun)))

    (define-key evil-normal-state-map (kbd "g]")
      (lambda () (interactive) (end-of-defun)))

    (define-key evil-normal-state-map (kbd "[ b") 'previous-buffer)
    (define-key evil-normal-state-map (kbd "] b") 'next-buffer)
    (define-key evil-motion-state-map (kbd "[ b") 'previous-buffer)
    (define-key evil-motion-state-map (kbd "] b") 'next-buffer)
    (define-key evil-normal-state-map (kbd "M-y") 'consult-yank-pop)

    (define-key evil-emacs-state-map (kbd "s-f") 'forward-word)
    (define-key evil-insert-state-map (kbd "s-f") 'forward-word)
    (define-key evil-insert-state-map (kbd "C-w") 'evil-delete-backward-word)
    (define-key evil-emacs-state-map (kbd "s-b") 'backward-word)
    (define-key evil-insert-state-map (kbd "s-b") 'backward-word)



    (define-key evil-ex-completion-map "\C-a" 'move-beginning-of-line)
    (define-key evil-ex-completion-map "\C-b" 'backward-char)
    (define-key evil-ex-completion-map "\C-k" 'kill-line)

    (define-key minibuffer-local-map (kbd "C-w") 'evil-delete-backward-word)

    (define-key evil-visual-state-map (kbd "C-r") 'zilongshanren/evil-quick-replace)


    ;; Don't move back the cursor one position when exiting insert mode
    (setq evil-move-cursor-back nil)

    (define-key evil-emacs-state-map (kbd "C-w") 'evil-delete-backward-word)

    (evil-define-key 'emacs term-raw-map (kbd "C-w") 'evil-delete-backward-word)


    (setq evil-normal-state-tag   (propertize "[N]" 'face '((:background "DarkGoldenrod2" :foreground "black")))
          evil-emacs-state-tag    (propertize "[E]" 'face '((:background "SkyBlue2" :foreground "black")))
          evil-insert-state-tag   (propertize "[I]" 'face '((:background "chartreuse3") :foreground "white"))
          evil-motion-state-tag   (propertize "[M]" 'face '((:background "plum3") :foreground "white"))
          evil-visual-state-tag   (propertize "[V]" 'face '((:background "gray" :foreground "black")))
          evil-operator-state-tag (propertize "[O]" 'face '((:background "purple"))))
    (setq evil-insert-state-cursor '("chartreuse3" bar))
    (define-key evil-insert-state-map (kbd "C-z") 'evil-emacs-state)


    ))

(use-package evil-anzu
  :ensure t
  :after evil
  :diminish
  :demand t
  :init
  (global-anzu-mode t))


(use-package evil-collection
  :ensure t
  :demand t
  :config
  (setq evil-collection-mode-list (remove 'lispy evil-collection-mode-list))
  (evil-collection-init)

   (cl-loop for (mode . state) in
            '((org-agenda-mode . normal)
              (Custom-mode . emacs)
              (makey-key-mode . motion))
            do (evil-set-initial-state mode state))


  (evil-define-key 'normal dired-mode-map
    (kbd "<RET>") 'dired-find-alternate-file
    (kbd "C-k") 'dired-up-directory
    "`" 'dired-open-term
    "o" 'dired-find-file-other-window
    "s" 'hydra-dired-quick-sort/body
    "z" 'dired-get-size
    "!" 'zilongshanren/do-shell-and-copy-to-kill-ring
    ")" 'dired-omit-mode)

  (when sys/win32p
    (evil-define-key 'normal dired-mode-map
      "s" 'dired-sort-toggle-or-edit))

  (evil-define-key 'normal help-mode-map
    "o" 'link-hint-open-link)
  )

(use-package undo-tree
  :diminish
  :init
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history nil)
  (evil-set-undo-system 'undo-tree))

(use-package evil-surround
  :ensure t
  :init
  (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :init
  (define-key evil-normal-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
  (define-key evil-visual-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)

  ;; (evilnc-default-hotkeys)
  )

(use-package evil-snipe
  :ensure t
  :diminish
  :init
  (evil-snipe-mode +1)
  (evil-snipe-override-mode +1))


(provide 'init-evil)
