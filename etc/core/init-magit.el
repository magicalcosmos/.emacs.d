;;; init-magit.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao


(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode +1))

(use-package git-timemachine
  :ensure t
  :defer 10)

(use-package magit
  :ensure t
  :bind ("C-M-;" . magit-status)
  :init
  ;; 必须在 Magit 加载前设置，保留代码自身的语法颜色
  (setq magit-diff-specify-hunk-foreground nil)
  :config
  ;; 光标移到差异块时再细化差异和语法高亮，避免一次处理所有差异
  (setq magit-diff-refine-hunk t
        magit-diff-fontify-hunk t
        magit-diff-use-indicator-faces t)
  :hook (magit-post-commit . git-gutter:update-all-windows))

;; 预加载 magit：把 require 的成本挪到 Emacs 启动期。
;;
;; magit-status 本身无论如何都要起 25 个 git 子进程（实测 2~5 秒，
;; 取决于机器负载），这部分省不掉；但首次 require magit 还有 1.3~4 秒的
;; 加载开销，延后到第一次按 C-M-; 时才付，感觉就是「打开 magit 很慢」。
;; 提前加载后，magit-status 只需付 25 个进程的成本。
;;
;; 放在 emacs-startup-hook 里而非直接 require，是为了让 Emacs 尽快出
;; 窗口——启动期的加载在帧显示之后进行。
;; 注意：batch 模式下 emacs-startup-hook 不会执行（见 init-basic.el 里的
;; 同类说明），此时 magit 仍是首次按键时才加载。
(defun init-magit--preload-magit ()
  "提前加载 magit，把 require 的成本挪到 Emacs 启动期。"
  (require 'magit)
  nil)

(add-hook 'emacs-startup-hook #'init-magit--preload-magit)

;; 状态页分区标题按类型着色（magit 所有标题共用一个 face，无现成选项）
(defface my/magit-heading-untracked
  '((t :inherit magit-section-heading :foreground "#b58900"))
  "Untracked files 分区标题颜色."
  :group 'magit-faces)
(defface my/magit-heading-unstaged
  '((t :inherit magit-section-heading :foreground "#cb4b16"))
  "Unstaged changes 分区标题颜色."
  :group 'magit-faces)
(defface my/magit-heading-staged
  '((t :inherit magit-section-heading :foreground "#859900"))
  "Staged changes 分区标题颜色."
  :group 'magit-faces)
(defface my/magit-heading-unpushed
  '((t :inherit magit-section-heading :foreground "#268bd2"))
  "Unpushed/Recent commits 分区标题颜色."
  :group 'magit-faces)

(defun my/magit-status-heading-colors ()
  "给 magit-status 各分区标题按类型覆盖颜色."
  (when (derived-mode-p 'magit-status-mode)
    (let ((faces '((untracked . my/magit-heading-untracked)
                   (unstaged  . my/magit-heading-unstaged)
                   (staged    . my/magit-heading-staged)
                   (unpushed  . my/magit-heading-unpushed)
                   (recent    . my/magit-heading-unpushed))))
      (dolist (section (oref magit-root-section children))
        (let ((face (alist-get (oref section type) faces)))
          (when face
            ;; magit 缓冲区只读，需临时解除才能加文本属性
            (let ((inhibit-read-only t))
              (put-text-property (oref section start)
                                 (save-excursion
                                   (goto-char (oref section start))
                                   (line-end-position))
                                 'face face))))))))
;; 注意：首次打开状态页走 magit-refresh-buffer，只跑 magit-refresh-buffer-hook；
;; magit-post-refresh-hook 仅在后续 g 刷新时执行，挂错钩子首次打开不着色
(add-hook 'magit-refresh-buffer-hook #'my/magit-status-heading-colors)

;; A git blame plugin for emacs inspired by VS Code’s GitLens plugin and Vim plugin
(use-package blamer
  :ensure t
  :bind (("s-i" . blamer-show-commit-info)
         ("C-c i" . blamer-show-posframe-commit-info))
  :defer 20
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                    :height 140
                    :italic t)))
)

(provide 'init-magit)