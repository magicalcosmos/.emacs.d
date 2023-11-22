(use-package kind-icon
  :ensure t
  :config
  (add-hook 'my-completion-ui-mode-hook
   	    (lambda ()
   	      (setq completion-in-region-function
   		    (kind-icon-enhance-completion
   		     completion-in-region-function)))))
(provide 'init-kind-icon)