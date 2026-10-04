;;; init-claude.el --- Claude Code 集成 -*- lexical-binding: t -*-
;;; Commentary:

;; claude-code.el —— 在 Emacs 内与 Claude Code CLI 交互
;; 依赖 Emacs 30+、Claude Code CLI（npm install -g @anthropic-ai/claude-code）
;; 终端后端使用 eat（纯 Elisp，无需编译原生模块，Windows/Linux/macOS 通用）

;;; Code:

;; Author: brodyliao

;; 依赖：inheritenv
(use-package inheritenv
  :straight (:type git :host github :repo "purcell/inheritenv"))

;; 终端后端：eat（纯 Elisp 终端模拟器，跨平台，无原生编译依赖）
(use-package eat
  :straight (:type git
                   :host codeberg
                   :repo "akib/emacs-eat"
                   :files ("*.el" ("term" "term/*.el") "*.texi"
                           "*.ti" ("terminfo/e" "terminfo/e/*")
                           ("terminfo/65" "terminfo/65/*")
                           ("integration" "integration/*")
                           (:exclude ".dir-locals.el" "*-tests.el"))))

;; 平台相关的桌面通知
(defun my/claude-code-notify (title message)
  "根据操作系统发送桌面通知."
  (cond
   ((eq system-type 'darwin)
    (call-process "osascript" nil nil nil
                  "-e" (format "display notification \"%s\" with title \"%s\" sound name \"Glass\""
                               message title)))
   ((eq system-type 'gnu/linux)
    (when (executable-find "notify-send")
      (call-process "notify-send" nil nil nil title message)))
   ((eq system-type 'windows-nt)
    (call-process "powershell" nil nil nil
                  "-Command"
                  (format "[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null; $x=[Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02); $t=[windows.ui.notifications.toastnotifier]::GetDefault(); $x.GetElementsByTagName('text').Item(0).AppendChild($x.CreateTextNode('%s'))|Out-Null; $x.GetElementsByTagName('text').Item(1).AppendChild($x.CreateTextNode('%s'))|Out-Null; $t.Show([Windows.UI.Notifications.ToastNotification]::new($x))" title message)))))

;; claude-code.el 本体，:depth 1 减少下载体积
(use-package claude-code
  :straight (:type git :host github :repo "stevemolitor/claude-code.el" :branch "main" :depth 1
                   :files ("*.el" (:exclude "images/*")))
  :custom
  (claude-code-terminal-backend 'eat) ; 跨平台终端后端
  (claude-code-notification-function #'my/claude-code-notify)
  :bind-keymap
  ("C-c c" . claude-code-command-map)
  :config
  (claude-code-mode)

  ;; kill 时强制关闭 Claude 窗口（上游 kill-buffer 不一定会关闭显示它的窗口）
  (defun my/claude-code-kill-delete-windows (buffer)
    "Kill 前先删除显示 BUFFER 的所有窗口."
    (when (and (buffer-live-p buffer)
               (> (length (window-list nil 0)) 1))
      (dolist (win (get-buffer-window-list buffer nil t))
        (condition-case nil
            (delete-window win)
          (error nil)))))
  (advice-add 'claude-code--kill-buffer :before
              #'my/claude-code-kill-delete-windows))

(provide 'init-claude)
