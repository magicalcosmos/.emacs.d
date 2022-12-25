
(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(define-key company-active-map (kbd "C-n") 'company-selet-next)
(define-key company-active-map (kbd "C-p") 'company-selet-previous)

;; 开启全局 Company 补全
(global-company-mode 1)

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package company-tabnine :ensure t)
(add-to-list 'company-backends #'company-tabnine)
;; Number the candidates (use M-1, M-2 etc to select completions).
(setq company-show-numbers t)
(provide 'init-company) 