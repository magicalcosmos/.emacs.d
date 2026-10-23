;;; init-dap-js.el --- JavaScript / Electron 调试（dap-mode） -*- lexical-binding: t -*-
;;; Commentary:

;; 依赖：dap-mode（已装在 elpa/）、Node.js（Volta 提供，node 22.x）
;;
;; 调试 Electron 需要两个会话：
;;   1. 主进程（main process）：type "pwa-node"，由 dap-js.el 注册
;;   2. 渲染进程（renderer）：type "pwa-chrome"，Electron 以 --inspect 启动，
;;      Chrome 调试适配器连上去
;;
;; js-debug 适配器（microsoft/vscode-js-debug）已下载到
;; .emacs.d/.extension/js-debug/。若被误删，用 M-x dap-js-setup 重新下载。
;;
;; 打断点：光标停在源码某行，M-x dap-breakpoint-toggle（或 C-c C-b）。
;; 断点经 dap-breakpoints-file 持久化，重启 Emacs 后仍在。
;;
;; 启动调试：M-x dap-debug -> 选择 "Electron Main Process" 等模板。
;; dap-debug 会弹出选择器，依次询问各字段。

;;; Code:

(require 'dap-mode)

;; dap-mode 的进程过滤器会读 `dap-exception-breakpoints'，而该变量只在
;; dap-ui.el 里定义。若 dap-ui 未加载，一启动调试会话就会报
;; "error in process filter: Symbol's value as variable is void:
;; dap-exception-breakpoints"，整个会话直接崩掉。
;; init-java.el 把 dap-auto-configure-mode 挂在 lsp-mode 上，那意味着必须
;; 先打开一个走 LSP 的文件才生效；调试 JS 时未必满足，这里直接全局开启。
;; （dap-auto-configure-mode 会连带启用 dap-ui-mode 与 dap-ui-many-windows-mode）
(dap-auto-configure-mode 1)

;; --- 断点与调试快捷键 -----------------------------------------------------
;; dap-mode 没有默认快捷键，这里给一组顺手的键位。
(define-key dap-mode-map (kbd "C-c C-b") #'dap-breakpoint-toggle)
(define-key dap-mode-map (kbd "C-c C-l") #'dap-debug-locals)
(define-key dap-mode-map (kbd "C-c C-r") #'dap-debug-restart)
(define-key dap-mode-map (kbd "C-c C-c") #'dap-continue)

;; --- 调试适配器 ------------------------------------------------------------
;; dap-js.el 注册 "pwa-node" 提供器（用 microsoft/vscode-js-debug 适配器，
;; 支持 Node 与 Electron 主进程）；dap-node.el 注册旧的 "node" 提供器。
(use-package dap-js
  :ensure nil
  :after dap-mode
  :config
  ;; 适配器已下载过则跳过；缺了就补下（幂等）
  (unless (file-exists-p dap-js-path)
    (dap-js-setup)))

;; --- 调试模板 -------------------------------------------------------------
;; :type "pwa-node"    —— js-debug 适配器，支持 Electron 主进程
;; :runtimeExecutable —— electron 可执行文件；nil 表示用 PATH 里的 electron
;; :runtimeArgs      —— 启动 Electron 时的额外参数
;; :program          —— Electron 主进程入口（package.json 的 main 字段）
;; :skipFiles        —— 跳过 node_modules 等无关文件
;;
;; 用法：M-x dap-debug -> 选模板 -> 依次填写各字段（带默认值的可直接回车）。
(dap-register-debug-template
 "Electron Main Process"
 (list :type "pwa-node"
       :request "launch"
       :name "Electron::Main"
       :runtimeExecutable nil
       :runtimeArgs '("--no-sandbox")
       :program nil
       :cwd nil
       :skipFiles '("node_modules" "electron")))

;; Electron 渲染进程：主进程以 --inspect 暴露 node 调试端口，
;; Chrome 调试适配器连上去调试渲染进程的 JS。
(dap-register-debug-template
 "Electron Renderer"
 (list :type "pwa-chrome"
       :request "launch"
       :name "Electron::Renderer"
       :runtimeExecutable nil
       :runtimeArgs '("--no-sandbox" "--inspect=9229")
       :program nil
       :cwd nil
       :port 9229
       :skipFiles '("node_modules" "electron")))

;; 纯 Node 脚本（后端服务 / 构建脚本），无需 Electron
(dap-register-debug-template
 "Node Script"
 (list :type "pwa-node"
       :request "launch"
       :name "Node::Script"
       :program nil
       :cwd nil
       :skipFiles '("node_modules")))

(provide 'init-dap-js)

;;; init-dap-js.el ends here
