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
(message "Arrow keys are bad, you know?"))


(use-package evil
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
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

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

(use-package evil-nerd-commenter
  :ensure t)

(use-package evil-collection
  :after evil
  :init
  (setq evil-collection-company-use-tng nil)  ;; Is this a bug in evil-collection?
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (setq evil-collection-mode-list
        (remove 'lispy evil-collection-mode-list))
  (evil-collection-init))
  
;; Emacs key bindings
(global-set-key (kbd "M-/") 'evilnc-comment-or-uncomment-lines)


(provide 'init-evil)
