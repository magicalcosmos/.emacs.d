(require 'lsp-bridge)
(setq lsp-bridge-enable-log nil)
(global-lsp-bridge-mode)

(evil-define-key 'normal lsp-bridge-ref-mode-map
  (kbd "RET") 'lsp-bridge-ref-open-file-and-stay
  "q" 'lsp-bridge-ref-quit)

(with-eval-after-load 'xref
  (setq xref-search-program 'ripgrep)     ;project-find-regexp
  (when (functionp 'xref-show-definitions-completing-read)
    (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
    (setq xref-show-xrefs-function #'xref-show-definitions-completing-read)))

(provide 'init-lsp-bridge)
