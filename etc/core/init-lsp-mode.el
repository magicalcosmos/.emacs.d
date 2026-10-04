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
  (lsp-idle-delay 0.500)
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-headerline-breadcrumb-enable t)
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
   (yaml-mode . lsp-deferred)
   (shell-mode . lsp-deferred)
   (dockerfile-mode . lsp-deferred)
   (vue-mode . lsp-deferred)
   (web-mode . lsp-deferred)
   )
  :config
  (setq lsp-idle-delay 0.500)
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