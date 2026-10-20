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

;; 终端后端：ghostel（libghostty 引擎，含原生 Windows ConPTY 支持；
;; eat 在原生 Windows 上硬编码 /usr/bin/env 启动器导致 spawning 错误，已弃用）
(use-package ghostel
  :straight (:type git
                   :host github
                   :repo "dakra/ghostel"
                   :files ("lisp/*.el" "etc" "extensions")
                   :depth 1)
  ;; 必须在 ghostel.el 加载前设置：它在文件加载顶层就按此目录加载原生模块；
  ;; :custom 在 require 之后才生效，会导致加载瞬间回退到包目录而报 module not found
  :init
  ;; Windows GUI Emacs 通常没有 HOME，~ 会回退到 AppData/Roaming，
  ;; 而模块在 C:/Users/<user>/.config 下，故锚定 USERPROFILE 而非 ~
  (setq ghostel-module-directory
        (if (eq system-type 'windows-nt)
            (expand-file-name ".config/emacs/ghostel/" (getenv "USERPROFILE"))
          (expand-file-name "~/.config/emacs/ghostel/"))))

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
    ;; PowerShell toast 通知；引号转义防止特殊字符破坏脚本
    (let ((ps-script
           (format "[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null; $x=[Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02); $t=[windows.ui.notifications.toastnotifier]::GetDefault(); $x.GetElementsByTagName('text').Item(0).AppendChild($x.CreateTextNode('%s'))|Out-Null; $x.GetElementsByTagName('text').Item(1).AppendChild($x.CreateTextNode('%s'))|Out-Null; $t.Show([Windows.UI.Notifications.ToastNotification]::new($x))"
                   (replace-regexp-in-string "'" "''" title)
                   (replace-regexp-in-string "'" "''" message))))
      (call-process "powershell" nil nil nil "-NoProfile" "-Command" ps-script)))))

;; claude-code.el 本体，:depth 1 减少下载体积
(use-package claude-code
  :straight (:type git :host github :repo "stevemolitor/claude-code.el" :branch "main" :depth 1
                   :files ("*.el" (:exclude "images/*")))
  :custom
  (claude-code-terminal-backend 'ghostel) ; libghostty 终端，Windows 原生支持
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
