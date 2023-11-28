(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)
(global-lsp-bridge-mode)

(with-eval-after-load 'xref
  (setq xref-search-program 'ripgrep)     ;project-find-regexp
  (when (functionp 'xref-show-definitions-completing-read)
    (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
    (setq xref-show-xrefs-function #'xref-show-definitions-completing-read)))

(with-eval-after-load 'lsp-bridge
      (setq acm-enable-quick-access t
            acm-quick-access-use-number-select t)
  )
 
  (general-nmap
    :states 'normal
    "gd" '(lsp-bridge-find-def :wk "jump to the definition")
    "gr" '(lsp-bridge-find-def :wk "find all references")
    "go" '(lsp-bridge-find-def-other-window :wk "jump to the definition in other-window")
    "gt" '(lsp-bridge-popup-documentation :wk " lookup documentation of symbol under the cursor")
    )

(provide 'init-lsp-bridge)
