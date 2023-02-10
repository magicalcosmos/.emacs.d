(require 'posframe)

(require 'lsp-bridge)
(setq +format-with-lsp nil)
(setq lsp-bridge-enable-log nil)
(global-lsp-bridge-mode)

(with-eval-after-load 'xref
  (setq xref-search-program 'ripgrep)     ;project-find-regexp
  (when (functionp 'xref-show-definitions-completing-read)
    (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
    (setq xref-show-xrefs-function #'xref-show-definitions-completing-read)))


  (general-nmap
    :states 'normal
    "gd" '(lsp-bridge-find-def :wk "jump to the definition")
    "gt" '(lsp-bridge-popup-documentation :wk " lookup documentation of symbol under the cursor")
    )

(provide 'init-lsp-bridge)
