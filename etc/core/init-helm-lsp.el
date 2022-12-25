(use-package helm-lsp
  :ensure t)

(helm-mode)

(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)




;; (bl/leader-key-def
;; "f"   '(:ignore t :which-key "files")
;; "ff"  '(helm-find-files :which-key "open file")
;; "fr"  '(helm-recentf :which-key "recent files")
;; "fR"  '(revert-buffer :which-key "revert file"))

(provide 'init-helm-lsp)