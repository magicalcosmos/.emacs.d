(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)
(global-lsp-bridge-mode)


(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package lsp-bridge
  :straight (:host github
             :repo "manateelazycat/lsp-bridge"
             :files ("*" (:exclude ".git")))
  :hook (after-init . global-lsp-bridge-mode)
  :custom
  (lsp-bridge-signature-function 'eldoc-message)
  (acm-markdown-render-font-height 80)
              (acm-doc-frame-max-lines 40)
            (acm-backend-codeium-candidate-min-length 3)
            (acm-backend-lsp-match-mode 'fuzzy)
  (lsp-bridge-multi-lang-server-extension-list
    '((("ts" "tsx") . "typescript_eslint"))))

    

(with-eval-after-load 'xref
  (setq xref-search-program 'ripgrep)     ;project-find-regexp
  (when (functionp 'xref-show-definitions-completing-read)
    (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
    (setq xref-show-xrefs-function #'xref-show-definitions-completing-read)))

(with-eval-after-load 'lsp-bridge
      (setq acm-enable-quick-access t)
  )
 
  (general-nmap
    :states 'normal
    "gd" '(lsp-bridge-find-impl :wk "jump to the definition")
    "gr" '(lsp-bridge-find-references :wk "find all references")
    "go" '(lsp-bridge-find-impl-other-window :wk "jump to the definition in other-window")
    "gt" '(lsp-bridge-popup-documentation :wk " lookup documentation of symbol under the cursor")
    )

(provide 'init-lsp-bridge)
