(setq lsp-clients-python-command "/usr/local/bin/pyls")
(setq lsp-vetur-server-command "/usr/local/bin/vls")

(use-package lsp-mode
  :hook (python-mode . lsp)
  :hook (vue-mode . lsp)
  :commands lsp)

(use-package lsp-ui
  :straight t
  :custom-face
  (lsp-ui-doc-background ((t (:background nil))))
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

(setq lsp-prefer-capf t)

(setq lsp-file-watch-ignored
  '(".idea" ".ensime_cache" ".eunit" "node_modules"
            ".git" ".hg" ".fslckout" "_FOSSIL_"
            ".bzr" "_darcs" ".tox" ".svn" ".stack-work"
            "build"))

(provide 'init-lsp-mode)