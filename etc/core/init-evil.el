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
  ;; (evil-auto-indent nil)
  :config
  (add-hook 'evil-mode-hook 'bl/evil-hook)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-paste-pop-next)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-paste-pop)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)  (unless bl/is-termux
    ;; Disable arrow keys in normal and visual modes
    (define-key evil-normal-state-map (kbd "<left>") 'bl/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<right>") 'bl/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<down>") 'bl/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<up>") 'bl/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<left>") 'bl/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<right>") 'bl/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<down>") 'bl/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<up>") 'bl/dont-arrow-me-bro))
  ;; (with-eval-after-load 'evil-maps
  ;;   (define-key evil-normal-state-map (kbd "gd") #'xref-find-definitions)
  ;;   (define-key evil-normal-state-map (kbd "<f12>") #'xref-find-definitions)
  ;;   (define-key evil-insert-state-map (kbd "C-n") nil) ; avoid conflict with company tooltip selection
  ;;   (define-key evil-insert-state-map (kbd "C-p") nil) ; avoid conflict with company tooltip selection
  ;;   (define-key evil-normal-state-map (kbd "C-p") nil) ; avoid conflict with WSL find-file
  ;;   (define-key evil-insert-state-map (kbd "C-S-C") #'evil-yank)         ; for WSL
  ;;   (define-key evil-normal-state-map (kbd "C-S-C") #'evil-yank)         ; for WSL
  ;;   (define-key evil-insert-state-map (kbd "C-S-V") #'evil-paste-before) ; for WSL
  ;;   )
  ;; Vim 风格 :q：多窗口时关闭当前窗口；唯一窗口时只隐藏当前 buffer，
  ;; 不退出 Emacs（避免误按 :q 直接关掉整个编辑器）
  (defun my/evil-quit ()
    "Like Vim :q. Close the current window; bury buffer on the last window."
    (interactive)
    (if (one-window-p)
        (bury-buffer)
      (delete-window)))
  (evil-ex-define-cmd "q" #'my/evil-quit)
  (evil-ex-define-cmd "wq" #'bl/save-and-kill-this-buffer)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(evil-mode 1)
(with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol)
    ;; make evil-search-word look for symbol rather than word boundaries
    (setq-default evil-symbol-word-search t))

;; `o` 的缩进行为：evil-auto-indent 调用 indent-according-to-mode，在 web-mode
;; 下遇到未闭合的 <div> / { 会自动钻进「内一层」，于是
;;   <template>          缩进 0 → 光标落在列 2
;;   <div class="box">   缩进 2 → 光标落在列 4
;;   function reset() {  缩进 0 → 光标落在列 2
;; 而闭括号行与普通语句行落点正常。写标签时希望留在同一层继续写子标签才用 O。
;; 这里让 `o` 保持当前行的缩进，其他行的智能缩进一律照旧。
(defun my/evil-open-below (&optional count)
  "Like `evil-open-below' but keep the new line at the current indentation.

Interactively use prefix COUNT to open that many lines below.
COUNT may be nil when invoked programmatically; treat it as 1."
  (interactive "p")
  (setq count (or count 1))
  (unless (eq evil-want-fine-undo t)
    (evil-start-undo-step))
  (push (point) buffer-undo-list)
  ;; 新行建立前先记住原行的缩进
  (let ((orig-indent (current-indentation)))
    (evil-insert-newline-below)
    (setq evil-insert-count count
          evil-insert-lines t
          evil-insert-vcount nil)
    (unwind-protect
        (progn
          ;; indent-according-to-mode 会重排新行，先删掉它插入的空白，
          ;; 再按原行缩进重填，否则叠加后总是差 1 列
          (delete-horizontal-space)
          (indent-to orig-indent))
      (evil-insert-state 1))))

;; evil-maps 在 evil 加载时才把 "o" 绑到 evil-open-below，必须在其之后覆盖。
;; 不用 evil-ex-define-cmd：ex 命令表是 evil 内部按命令名分发的，直接写 "o"
;; 会让 ex 的 command 分发器把 my/evil-open-below 当成无参命令调用而报错。
;; 退路用普通 keymap 绑定。
(eval-after-load 'evil-maps
  (define-key evil-normal-state-map (kbd "o") #'my/evil-open-below))

;; 需要原版自动钻取缩进时的退路
(define-key evil-normal-state-map (kbd "C-c o") #'evil-open-below)

(use-package evil-nerd-commenter
  :ensure t
  :init
    (define-key evil-normal-state-map (kbd "M-/") 'evilnc-comment-or-uncomment-lines)
    (define-key evil-visual-state-map (kbd "M-/") 'evilnc-comment-or-uncomment-lines))

(use-package evil-collection
  :ensure t
  :after evil
  :init
  (setq evil-collection-company-use-tng nil)  ;; Is this a bug in evil-collection?
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (setq evil-collection-mode-list
        (remove 'lispy evil-collection-mode-list))
  (evil-collection-init))

;; (defalias 'forward-evil-word 'forward-evil-symbol)

(provide 'init-evil)