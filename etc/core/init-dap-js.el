;;; init-dap-js.el --- JavaScript / Electron 调试（dap-mode） -*- lexical-binding: t -*-
;;; Commentary:

;; 调试 Electron 需要两个会话：
;;   1. 主进程（main process）：type "pwa-node"
;;   2. 渲染进程（renderer）：type "pwa-chrome"
;;
;; 【主进程为什么用 launch 而不是 attach】
;; attach（连已运行的 Electron 的 --inspect 端口）看着简单，但实测断点
;; 一直是 "breakpoint.provisionalBreakpoint"（未绑定到已加载的脚本），
;; 断点永远不生效——因为 attach 发生在 Electron 加载完主进程脚本之后，
;; 适配器无从把它映射回去。
;;
;; launch 则是让 js-debug 自己启动 electron-vite，由它注入
;; NODE_OPTIONS=--require <bootloader>，js-debug 再自动 attach 到
;; electron-vite 派生的 Electron 子进程（autoAttachChildProcesses）。
;; 这样断点能正确绑定，实测停在 .ts 源文件的正确行。
;;
;; 关键点：runtimeExecutable 必须是 node、program 指向 electron-vite 的
;; js 入口。不能直接用 node_modules/.bin/electron-vite.cmd —— 那是 cmd
;; 批处理 shim，Emacs 无法作为进程直接执行。
;;
;; 【每个项目自带配置】
;; 配置放在项目根目录的 .dap-js.el 或 .dap-js.json 里，Emacs 打开该项目
;; 时自动读取，各项目的 mode、端口、启动参数都不写死在全局配置里：
;;
;;   ;; .dap-js.el（项目根目录）
;;   (setq my/dap-js-config
;;         '(:name "gxrcub_pc"
;;           :dev-args ("dev" "--mode" "dev-desmart-jdk17")
;;           :main-port 9229
;;           :renderer-port 9222))
;;
;; Emacs 侧的用法：
;;
;;   M-x my/dap-js-debug-main   —— 启动并调试主进程（断点需先设好）
;;   M-x my/dap-js-debug-renderer —— 调试渲染进程
;;   M-x dap-breakpoint-toggle （或 C-c C-b）—— 在当前行打断点
;;
;; 断点经 dap-breakpoints-file 持久化，重启 Emacs 后仍在。
;;
;; js-debug 适配器（microsoft/vscode-js-debug）已下载到
;; .emacs.d/.extension/js-debug/。若被误删，用 M-x dap-js-setup 重新下载。

;;; Code:

(require 'dap-mode)

;; `process-environment' 是 env.el 里的变量，该文件默认不加载
(require 'env)

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
;; 局部变量由 dap-ui 的 locals 窗口显示（dap-auto-configure-mode 已开启
;; locals 特性），没有单独的 dap-debug-locals 命令。
(define-key dap-mode-map (kbd "C-c C-b") #'dap-breakpoint-toggle)
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

;; --- 项目级配置 ------------------------------------------------------------
;; 配置来源（按优先级）：
;;   1. 项目根目录的 .dap-js.el    —— elisp 形式，最灵活
;;   2. 项目根目录的 .dap-js.json  —— JSON 形式
;;   3. 找不到时用内置默认值

(defvar my/dap-js-config
  '(:name "default"
    ;; electron-vite dev 的参数（不含 "electron-vite" 本身）
    :dev-args ("dev")
    ;; 主进程调试端口，同时给渲染进程用（Electron 的 --remote-debugging-port）
    :main-port 9229
    ;; 渲染进程 Chrome 调试端口
    :renderer-port 9222
    ;; 渲染进程免沙箱
    :no-sandbox t)
  "内置的默认项目配置（plist）。
项目根目录下的 .dap-js.el / .dap-js.json 会覆盖它。")

(defvar my/dap-js--config-cache nil
  "缓存的当前项目配置，nil 表示尚未读取。")

(defun my/dap-js--project-root ()
  "返回当前项目的根目录，找不到则返回 nil。
判据：向上查找含 package.json 的目录。"
  (let ((dir (or (and (buffer-file-name) (file-name-directory (buffer-file-name)))
                  default-directory)))
    (when dir
      (let ((found nil))
        (while (and dir (not found))
          (let ((pkg (expand-file-name "package.json" dir)))
            (when (file-exists-p pkg)
              (setq found dir)))
          (let ((parent (file-name-directory (directory-file-name dir))))
            (unless (equal parent dir)
              (setq dir parent))))
        found))))

(defun my/dap-js--read-project-config (root)
  "读取 ROOT 下的项目级配置，返回配置 plist，没有则返回 nil。
优先 .dap-js.el，其次 .dap-js.json。"
  (when root
    (let ((el (expand-file-name ".dap-js.el" root))
          (json (expand-file-name ".dap-js.json" root)))
      (cond
       ((file-exists-p el)
        (with-temp-buffer
          (insert-file-contents el)
          (goto-char (point-min))
          (let ((form (read (current-buffer))))
            ;; 允许写成 (setq my/dap-js-config ...) 或直接一个 plist
            (if (and (consp form) (eq (car form) 'setq)
                     (symbolp (nth 1 form)))
                (eval (nth 2 form))
              form))))
       ((file-exists-p json)
        (with-temp-buffer
          (insert-file-contents json)
          (goto-char (point-min))
          (let ((json-object-type 'plist)
                (json-array-type 'vector))
            (json-read))))))))

(defun my/dap-js--merge-config (base override)
  "把 OVERRIDE 合并进 BASE（都是配置 plist），OVERRIDE 优先。"
  (if (null override)
      base
    (let ((result (copy-sequence base)))
      (let ((tail override))
        (while tail
          (setq result (plist-put result (car tail) (cadr tail))
                tail (cddr tail))))
      result)))

(defun my/dap-js-current-config ()
  "返回当前生效的项目配置（plist）。
查找项目根目录的 .dap-js.el / .dap-js.json，缺失时用 `my/dap-js-config'。"
  (or my/dap-js--config-cache
      (let* ((root (my/dap-js--project-root))
             (override (my/dap-js--read-project-config root)))
        (setq my/dap-js--config-cache
              (my/dap-js--merge-config my/dap-js-config override))
        my/dap-js--config-cache)))

(defun my/dap-js--config-get (key &optional config)
  "取配置里的 KEY 值，CONFIG 缺省用当前项目配置。"
  (plist-get (or config (my/dap-js-current-config)) key))

(defun my/dap-js--config-name (&optional config)
  "取配置的项目名，CONFIG 缺省用当前项目配置。"
  (or (my/dap-js--config-get :name config) "default"))

(defun my/dap-js--config-dev-args (&optional config)
  "取配置的 electron-vite dev 参数，CONFIG 缺省用当前项目配置。"
  (or (my/dap-js--config-get :dev-args config) '("dev")))

(defun my/dap-js--config-main-port (&optional config)
  "取配置的主进程调试端口，CONFIG 缺省用当前项目配置。"
  (or (my/dap-js--config-get :main-port config) 9229))

(defun my/dap-js--config-renderer-port (&optional config)
  "取配置的渲染进程调试端口，CONFIG 缺省用当前项目配置。"
  (or (my/dap-js--config-get :renderer-port config) 9222))

(defun my/dap-js--reset-config-cache ()
  "清空项目配置缓存，下次调用时重新读取。"
  (interactive)
  (setq my/dap-js--config-cache nil))

;; --- 定位项目里的可执行文件 ------------------------------------------------
(defun my/dap-js--electron-vite-entry (root)
  "返回 ROOT 下 electron-vite 的 js 入口路径，找不到返回 nil。
必须是 js 入口而不是 .bin 下的 .cmd —— cmd 批处理 shim 无法作为进程直接
执行，js-debug 的 runtimeExecutable 只能是 node 这类真正的可执行文件。"
  (when root
    (let ((entry (expand-file-name
                  "node_modules/electron-vite/bin/electron-vite.js" root)))
      (when (file-exists-p entry) entry))))

(defun my/dap-js--electron-executable (root)
  "返回 ROOT 下 node_modules/electron 的可执行文件路径，找不到返回 nil。"
  (when root
    (let ((path-file (expand-file-name "node_modules/electron/path.txt" root)))
      (when (file-exists-p path-file)
        (let* ((exe (string-trim (with-temp-buffer
                                   (insert-file-contents path-file)
                                   (buffer-string))))
               (full (expand-file-name (concat "node_modules/electron/dist/" exe) root)))
          (when (file-exists-p full) full))))))

;; --- 启动并调试主进程 ------------------------------------------------------
(defun my/dap-js--main-launch-args ()
  "构造主进程调试会话的 launch 参数（plist）。
由 js-debug 启动 electron-vite，再自动 attach 到它派生的 Electron。"
  (let* ((root (or (my/dap-js--project-root) default-directory))
         (config (my/dap-js-current-config))
         (renderer-port (my/dap-js--config-renderer-port config)))
    (list :type "pwa-node"
          :request "launch"
          :name "Electron::Main"
          :runtimeExecutable "node"
          :program (or (my/dap-js--electron-vite-entry root)
                        (error "[dap-js] 项目 %s 下找不到 electron-vite，无法启动调试" root))
          :args (my/dap-js--config-dev-args config)
          :cwd root
          :env (list (cons "REMOTE_DEBUGGING_PORT" (number-to-string renderer-port))
                     (cons "NO_SANDBOX" "1"))
          :autoAttachChildProcesses t
          ;; electron-vite 构建出的 out/main/index.js 末尾带
          ;; `//# sourceMappingURL=index.js.map'（相对路径），js-debug 能顺着
          ;; 找到 map，再由 map 的 sources 字段定位回 .ts 源文件。
          :outFiles (list (expand-file-name "out/main/**/*.js" root))
          :skipFiles '("node_modules" "electron/dist"))))

(defun my/dap-js-debug-main ()
  "按当前项目配置启动 electron-vite 并调试主进程。
断点请先在源码里设好（M-x dap-breakpoint-toggle）。"
  (interactive)
  (let ((config (my/dap-js-current-config)))
    (message "[dap-js] 启动 %s 的主进程调试（%S）"
             (my/dap-js--config-name config)
             (my/dap-js--config-dev-args config))
    (dap-debug (my/dap-js--main-launch-args))))

;; --- 调试渲染进程 ----------------------------------------------------------
(defun my/dap-js-debug-renderer ()
  "调试渲染进程（需主进程已在运行并开放了 Chrome 调试端口）。
主进程启动时带上 --remote-debugging-port，渲染进程才能被 attach。"
  (interactive)
  (let* ((root (or (my/dap-js--project-root) default-directory))
         (config (my/dap-js-current-config))
         (port (my/dap-js--config-renderer-port config)))
    (dap-debug
     (list :type "pwa-chrome"
           :request "attach"
           :name "Electron::Renderer"
           :address "localhost"
           :port port
           :webRoot (expand-file-name "src/renderer" root)
           :timeout 30000
           :skipFiles '("node_modules" "electron/dist")))))

;; --- 独立启动开发环境（不进入调试） ------------------------------------------
(defun my/dap-js--current-env (&rest overrides)
  "返回进程环境（alist），把 OVERRIDES 里的项覆盖进去。
OVERRIDES 是 (NAME . VALUE) 形式的列表。"
  (let ((env (copy-sequence process-environment)))
    (dolist (kv overrides)
      (setq env (cons kv (assq-delete-all (car kv) env))))
    env))

(defun my/dap-js-launch-dev ()
  "按当前项目配置启动 electron-vite dev，并打开调试端口。
用于先跑起来看看效果，不挂调试器。"
  (interactive)
  (let* ((root (or (my/dap-js--project-root) default-directory))
         (config (my/dap-js-current-config))
         (main-port (my/dap-js--config-main-port config))
         (renderer-port (my/dap-js--config-renderer-port config))
         (bin (expand-file-name "node_modules/.bin/electron-vite" root))
         (cmd (if (file-exists-p bin) bin "npx"))
         (args (if (file-exists-p bin)
                   (my/dap-js--config-dev-args config)
                 (cons "electron-vite" (my/dap-js--config-dev-args config))))
         ;; electron-vite 2.x 的 CLI 选项最终就是这几个环境变量
         (env (my/dap-js--current-env
               (cons "V8_INSPECTOR_PORT" (number-to-string main-port))
               (cons "REMOTE_DEBUGGING_PORT" (number-to-string renderer-port))
               (cons "NO_SANDBOX" "1")))
         (proc (apply #'start-process
                      "electron-vite-dev"
                      nil
                      cmd
                      args
                      :environment env)))
    (message "[dap-js] %s 已在 %s 启动（主进程端口 %s，渲染进程端口 %s）"
             (my/dap-js--config-name config)
             root main-port renderer-port)
    proc))

;; --- 调试模板 -------------------------------------------------------------
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
