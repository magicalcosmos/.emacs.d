;; (use-package dap-mode
;;   :hook (dap-mode . dap-tooltip-mode)
;;   :hook (dap-mode . dap-ui-mode)
;;   :hook (dap-ui-mode . dap-ui-controls-mode)
;;   :bind ("C-c p d" . dap-hydra)
;;   :init
;;   (setq dap-breakpoints-file (concat CACHE-DIR "dap-breakpoints")
;;         dap-utils-extension-path (concat CACHE-DIR "dap-extension"))
;;   :config
;;   (dap-mode 1)
;;   (add-hook 'dap-stopped-hook
;;             (lambda (arg) (call-interactively #'dap-hydra))))
            
(use-package dap-mode
  :bind
  (:map dap-mode-map
   ("C-c b b" . dap-breakpoint-toggle)
   ("C-c b r" . dap-debug-restart)
   ("C-c b l" . dap-debug-last)
   ("C-c b d" . dap-debug))
  :init
  (require 'dap-go)
  ;; NB: dap-go-setup appears to be broken, so you have to download the extension from GH, rename its file extension
  ;; unzip it, and copy it into the config so that the following path lines up
  (setq dap-go-debug-program '("node" "/Users/brodyliao/.config/emacs/.extension/vscode/golang.go/extension/dist/debugAdapter.js"))
  (defun pt/turn-on-debugger ()
    (interactive)
    (dap-mode)
    (dap-auto-configure-mode)
    (dap-ui-mode)
    (dap-ui-controls-mode)
    )

(provide 'init-dap-mode)
