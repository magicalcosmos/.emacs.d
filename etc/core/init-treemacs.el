;;; init-treemacs.el --- 文件树 -*- lexical-binding: t -*-
(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-files-by-mouse-dragging    t
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name "treemacs-persist" CACHE-DIR)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    ;; C-x t t 打开文件树时自动定位当前文件；项目不在 workspace 时先添加
    (defun my/treemacs-open-and-follow ()
      "打开文件树并定位到当前文件."
      (interactive)
      (if (buffer-file-name)
          (if (treemacs--find-project-for-path (buffer-file-name))
              (treemacs-find-file)
            (treemacs-add-and-display-current-project))
        (treemacs)))

    ;; E：在系统文件管理器中定位光标下的文件/目录（打开所在位置并选中）
    (defun my/treemacs-reveal-in-explorer ()
      "Reveal the file at point in the system file manager."
      (interactive)
      (if-let* ((btn (treemacs-current-button))
                (path (treemacs--nearest-path btn)))
          (pcase system-type
            ('windows-nt
             ;; explorer /select, 对参数格式极挑剔（start-process 会把含引号
             ;; 参数转义、部分 Win11 场景直接忽略），改用 Shell.Application
             ;; COM 的 SelectItem，实测稳定。见 etc/lisp/reveal-in-explorer.ps1
             (start-process "reveal-explorer" nil "powershell.exe"
                            "-NoProfile" "-ExecutionPolicy" "Bypass"
                            "-File" (expand-file-name
                                     "etc/lisp/reveal-in-explorer.ps1"
                                     user-emacs-directory)
                            "-Path" path))
            ('darwin
             (shell-command (format "open -R %S" path)))
            ('gnu/linux
             (shell-command
              (format "xdg-open %S" (directory-file-name (file-name-directory path))))))
        (treemacs-pulse-on-failure "Nothing under point to reveal.")))

    ;; 必须绑到 evil-treemacs-state-map 本体：treemacs state 启用了 motion
    ;; state，普通 define-key / evil-define-key 辅助映射的 E/e 都会被
    ;; evil 移动命令（move-end-of-line / forward-word-end）挡住，表现为按了
    ;; 没反应。state map 本体优先级最高（treemacs-evil 的 j/k 也绑在这层）。
    ;; e 原本的 treemacs-edit-workspaces 在 evil 下同样被挡，仍可用 M-x 调用。
    (with-eval-after-load 'treemacs-evil
      (define-key evil-treemacs-state-map
                  (kbd "E") #'my/treemacs-reveal-in-explorer)
      (define-key evil-treemacs-state-map
                  (kbd "e") #'my/treemacs-reveal-in-explorer))
    )
  :bind
    (:map global-map
          ("C-0"       . treemacs-select-window)
          ("C-x t 1"   . treemacs-delete-other-windows)
          ("C-x t t"   . my/treemacs-open-and-follow)
          ("C-x t d"   . treemacs-select-directory)
          ("C-x t B"   . treemacs-bookmark)
          ("C-x t C-t" . treemacs-find-file)
          ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(provide 'init-treemacs)