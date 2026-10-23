;;; init-lsp-mode.el --- LSP 补全/跳转 -*- lexical-binding: t -*-
(use-package lsp-mode
  :ensure t
  :custom
  ;; 新版 lsp-mode 已移除 company 集成，纯 completion-at-point，与 corfu 天然配合
  (lsp-enable-snippet nil)         ;; 未安装 yasnippet，关闭 snippet 候选
  (lsp-keep-workspace-alive t)
  (lsp-enable-xref t)
  (lsp-enable-imenu t)
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.300)
  ;; 不复用上一次的候选结果。注意：ts-ls 对 `.value' 仍会返回全量符号表
  ;; （实测 1007 个候选），此选项只影响 Emacs 侧缓存复用，不减少单次返回量；
  ;; 真正的过滤发生在 corfu/orderless 层。过滤开销是否为主要瓶颈尚未实测。
  (lsp-completion-use-last-result nil)
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-headerline-breadcrumb-enable t)
  ;; Windows 上默认的 tar 解压脚本会失败：lsp-mode 用
  ;;   bash -c 'mkdir -p %2$s; tar xf %1$s --directory=%2$s'
  ;; 其中路径是 "C:/Users/..." 形式，Git 自带的 MSYS tar 会把 "C:" 当成
  ;; 远程主机名，报 "tar: Cannot connect to c: resolve failed"，解压静默失败。
  ;; 改用 Windows 自带的 bsdtar（C:\Windows\System32\tar.exe，PATH 上
  ;; executable-find "tar" 优先命中它），它认 "C:/" 路径；建目录交给
  ;; PowerShell 的 New-Item（cmdproxy 不支持 cmd 的 && 连接符）。
  ;; 影响面：所有经 lsp-download-install 下载的 VSCode 扩展
  ;; （js-debug、chrome 调试适配器等）。
  (lsp-tar-script
   (lambda ()
     (concat
      "powershell -NoProfile -Command \""
      "New-Item -ItemType Directory -Force -Path %2$s | Out-Null; "
      "tar -xf %1$s -C %2$s"
      "\"")))
  :bind (
    ("C-c l" . lsp-command-map)
    ("C-c d" . lsp-describe-thing-at-point)
    ("C-c a" . lsp-execute-code-action)
  )
  :hook (
   (go-mode . lsp-deferred)   ;; 做跳转用的hook
   (dart-mode . lsp-deferred)
   (json-mode . lsp-deferred)
   (css-mode . lsp-deferred)
   (scss-mode . lsp-deferred)
   (html-mode . lsp-deferred)
   (python-mode . lsp-deferred)
   (c-mode . lsp-deferred)
   (js-jsx-mode . lsp-deferred)
   (typescript-mode . lsp-deferred)
   (web-mode . lsp-deferred)
   (yaml-mode . lsp-deferred)
   (shell-mode . lsp-deferred)
   (dockerfile-mode . lsp-deferred)
   )
  :config
  (setq lsp-idle-delay 0.300)
  ;; evil 下用 LSP 跳转替代默认的 gd（evil-jump-to-definition 走 tags，不识别模块路径）
  (with-eval-after-load 'evil
    (evil-define-key 'normal lsp-mode-map
      "gd" #'lsp-find-definition
      "gr" #'lsp-find-references
      "K"  #'lsp-describe-thing-at-point))
  (setq lsp-log-io nil)  ;; Don't log everything = speed
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-restart 'auto-restart)
  (setq lsp-auto-guess-root nil)
  (setq lsp-diagnostic-package t)
  (setq lsp-diagnostic-package :none)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-enable-folding nil)
  ;; (setq read-process-output-max (* 1024 1024)) ;; 1mb
)

;; Vue3 支持：vue-semantic-server（Volar）是 add-on 客户端，依赖 ts-ls 配合
;; （tsserver/request 转发）。需全局安装：volta install typescript typescript-language-server
;; .vue 由 web-mode 接管（见 init-web.el），lsp-mode 按文件后缀激活 Volar
(defun my/volar-tsdk ()
  "Return a TypeScript lib dir containing tsserver.js, or nil.

Volar 自带 TypeScript 7（Go 重写版），其 npm 包不含 ts.server 命名空间，
而 Volar 的 server.js 直接访问 ts.server.protocol，会抛 TypeError 退出。
必须指向 TypeScript 5.x 的 lib 目录。

候选来源依次为：node 解析到的 typescript、lsp-mode 解析的 tsserver 路径
（其父目录）、以及 typescript-language-server 同级的 npm 目录。"
  (let (candidates)
    ;; 1) node 自身解析到的 typescript（与 Volar index.js --tsdk= 的解析方式一致）
    (ignore-errors
      (when-let* ((node (executable-find "node"))
                  (out (with-temp-buffer
                         (call-process node nil t nil "-p"
                                       "require('path').dirname(require.resolve('typescript/lib/typescript.js'))")
                         (buffer-string)))
                  (dir (string-trim out))
                  ((not (string-prefix-p "Error" dir))))
        (push dir candidates)))
    ;; 2) lsp-mode 解析到的 tsserver：Windows 上是 .cmd shim，父目录不是 lib
    (ignore-errors
      (let ((ts (lsp-package-path 'typescript)))
        (when ts
          (push (file-name-directory ts) candidates))))
    ;; 3) typescript-language-server 所在 node_modules 里的 typescript
    (ignore-errors
      (let ((tls (lsp-package-path 'typescript-language-server)))
        (when tls
          (push (expand-file-name
                 "../../../typescript/node_modules/typescript/lib"
                 (file-name-directory tls))
                candidates))))
    (seq-find (lambda (dir)
                (and dir
                     (file-exists-p (expand-file-name "tsserver.js" dir))))
              candidates)))

(defun my/volar-plugin-location ()
  "Return a node_modules dir from which ts-ls can load @vue/typescript-plugin.

Without the plugin, ts-ls has no idea that .vue files contain TypeScript, so
completion inside <script setup> knows nothing about `ref' and friends.
lsp-volar's :auto detection assumes a flat npm layout that lsp-mode's
@vue/language-server install does not use, so resolve it ourselves."
  (let ((server (ignore-errors (lsp-package-path 'volar-language-server)))
        (found nil)
        (seen (make-hash-table :test 'equal))
        (queue '()))
    (when server
      (push (file-name-as-directory (file-name-directory server)) queue))
    (while (and queue (not found))
      (let* ((dir (pop queue))
             (nm (file-name-as-directory (expand-file-name "node_modules" dir))))
        (unless (gethash nm seen)
          (puthash nm t seen)
          (when (file-exists-p
                 (expand-file-name "@vue/typescript-plugin/package.json" nm))
            (setq found nm))
          ;; lsp-mode 把 @vue/language-server 装成嵌套布局，插件在其
          ;; node_modules 下，需再下潜一层
          (when (file-directory-p
                 (expand-file-name "@vue/language-server" nm))
            (push (file-name-as-directory
                   (expand-file-name "@vue/language-server/node_modules" nm))
                  queue))
          ;; 同时继续向上找（项目本地 node_modules 优先于全局）
          (let ((parent (file-name-directory (directory-file-name dir))))
            (unless (equal parent dir)
              (push (file-name-as-directory parent) queue))))))
    found))

(with-eval-after-load 'lsp-volar
  ;; @vue/typescript-plugin 位置：lsp-volar 的 :auto 探测假设扁平 npm 布局，
  ;; 与 lsp-mode 实际安装路径不符，导致 ts-ls 加载不到插件 → .vue 的
  ;; <script setup> 块里没有补全（pricePage. 无提示）。
  ;; 注意：lsp-volar.el 在被 require 时就把插件位置写进了
  ;; lsp-clients-typescript-plugins，所以事后 setq 该变量已太晚，
  ;; 必须直接改写向量里的 :location。
  (let ((loc (my/volar-plugin-location)))
    (if (not loc)
        (lsp--warn "[init-lsp-mode] 未找到 @vue/typescript-plugin，Vue script 块将无补全")
      (setq lsp-volar-location-for-typescript-plugin loc)
      (let ((plugins lsp-clients-typescript-plugins)
            (i 0))
        (while (< i (length plugins))
          (when (equal (plist-get (aref plugins i) :name) "@vue/typescript-plugin")
            (aset plugins i
                  (plist-put (aref plugins i) :location loc)))
          (setq i (1+ i)))
        (setq lsp-clients-typescript-plugins plugins))))
  ;; lsp-mode 内置的 Volar 客户端只传 --stdio，Volar 会退回到自带的 TS7 并崩溃。
  ;; 重新注册一个带 --tsdk= 的客户端（priority 更高以覆盖内置的 0）。
  (let ((tsdk (my/volar-tsdk)))
    (if (not tsdk)
        (lsp--warn "[init-lsp-mode] 未找到含 tsserver.js 的 TypeScript 5.x，\
Vue LSP 会因 Volar 自带 TS7 而崩溃。执行：volta install typescript@5.9.3")
      (lsp-register-client
       (make-lsp-client
        :new-connection (lsp-stdio-connection
                         (lambda ()
                           (list (lsp-package-path 'volar-language-server)
                                 (format "--tsdk=%s" tsdk)
                                 "--stdio")))
        :activation-fn 'lsp-volar--activate-p
        :priority 100
        :multi-root nil
        :add-on? t
        :server-id 'vue-semantic-server
        :initialization-options (lambda () (ht-merge (lsp-configuration-section "vue")))
        :notification-handlers
        (ht ("tsserver/request" #'lsp-volar--tsserver-request-handler))
        :download-server-fn (lambda (_client callback error-callback _update?)
                              (lsp-package-ensure 'volar-language-server
                                                  callback error-callback)))))))

(use-package lsp-ui
  :ensure t
  :custom-face
  (lsp-ui-doc-background ((t (:background unspecified))))
  :init (setq lsp-ui-sideline-enable nil
              lsp-ui-peek-enable nil
              lsp-ui-doc-enable t
              lsp-ui-doc-position              'at-point
              lsp-ui-doc-header                nil
              lsp-ui-doc-border                "white"
              lsp-ui-doc-include-signature     t

              lsp-ui-sideline-show-diagnostics t
              lsp-ui-sideline-update-mode      'point
              lsp-ui-sideline-delay            2
              lsp-ui-sideline-ignore-duplicate t
              lsp-ui-sideline-show-hover t
              lsp-ui-sideline-show-code-actions t


              lsp-ui-peek-always-show          t
              lsp-ui-flycheck-enable           nil

              lsp-ui-imenu-auto-refresh t

              lsp-ui-peek-jump-backward t
              lsp-ui-peek-jump-backward t
              lsp-ui-peek-find-workspace-symbol "pattern 0"
              ;; If the server supports custom cross references
              lsp-ui-peek-find-custom "$cquery/base"
              lsp-ui-peek-show-directory t
              )
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . lsp-ui-peek-find-references)
              ("C-c u" . lsp-ui-imenu))
  :config
  (setq lsp-ui-sideline-ignore-duplicate t)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

  ;; (add-hook 'web-mode-hook #'lsp-flycheck-enable) ; enable flycheck-lsp for web-mode locally

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.vscode\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.cache\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\node_modules\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.log\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.history\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.husky\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.tmp\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\static\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\dist\\'")
  ;; (add-to-list 'lsp-language-id-configuration '(web-mode . "lsp"))
  ;;      (lsp-register-client
  ;;     ;; Git clone language server from https://github.com/lifeart/ember-language-server/tree/component-context-info-origin
  ;;     ;; And build it
  ;;      (make-lsp-client :new-connection (lsp-stdio-connection (list "node" (expand-file-name "~/www/ember-language-server/lib/start-server.js") "--stdio"))
  ;;                       :activation-fn (lsp-activate-on "hbs")
  ;;                       :server-id 'ember-language-server)))
  ;; or
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.*\\'"))

(provide 'init-lsp-mode)