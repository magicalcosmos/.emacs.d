
(use-package lsp-mode
  :ensure t
  :custom
  (lsp-enable-snippet t)
  (lsp-keep-workspace-alive t)
  (lsp-enable-xref t)
  (lsp-enable-imenu t)
  (lsp-enable-completion-at-point t)
  (lsp-eldoc-hook nil)
  
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.500)
  ;; enable / disable the hints as you prefer:
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  (lsp-completion-provider :none) ;; 阻止 lsp 重新设置 company-backend 而覆盖我们 yasnippet 的设置
  (lsp-headerline-breadcrumb-enable t)
  (lsp-treemacs-sync-mode 1)
  (lsp-completion-enable nil)

  ;; js
  (lsp-javascript-suggest-complete-js-docs nil)
  (lsp-javascript-auto-closing-tags nil)
  (lsp-javascript-suggest-enabled nil)
  (lsp-javascript-suggest-auto-imports nil)
  (lsp-Javascript-suggestion-actions-enabled nil)
  ;; ts
  (lsp-typescript-auto-closing-tags nil)
  (lsp-typescript-suggest-auto-imports nil)
  (lsp-typescript-suggest-enabled nil)
  (lsp-typescript-suggest-complete-js-docs nil)
  (lsp-typescript-suggestion-actions-enabled nil)

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
   (html-mode . lsp-deferred)
   (python-mode . lsp-deferred)
   (c-mode . lsp-deferred)
   (js-jsx-mode . lsp-deferred)
   (typescript-mode . lsp-deferred)
   (ymal-mode . lsp-deferred)
   (shell-mode . lsp-deferred)
   (dockerfile-mode . lsp-deferred)
   (vue-mode . lsp-deferred)
   (web-mode . lsp-deferred)
   (lsp-mode . lsp-enable-which-key-integration)
   )
  :commands (lsp lsp-deferred)
  :config
  (setq company-minimum-prefix-length 1)
  (setq lsp-idle-delay 0.500)
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
  :init (setq lsp-enable-snippet nil
              lsp-ui-sideline-enable nil
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
  ;; (add-to-list 'lsp-language-id-configuration '(js-jsx-mode . "javascriptreact"))
  ;; or
  (add-to-list 'lsp-file-watch-ignored-files "[/\\\\]\\.*\\'"))
  
(provide 'init-lsp-mode)
