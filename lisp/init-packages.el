;; cl - Common Lisp Extension
(require 'cl)

;;optimise loading package
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")))


;;add whatever packages you want here
 (defvar brodyliao/packages '(
		;; --- Auto-completion ---
			      company
			      popwin
		;; --- Better Editor ---
		hungry-delete
		swiper
		counsel
		smartparens
		;; --- Major Mode ---
		js2-mode
		;; --- Minor Mode ---
		nodejs-repl
		exec-path-from-shell
		;; --- Themes ---
a		gruvbox-theme
		;; solarized-theme
		) "Default packages")

(setq package-selected-packages brodyliao/packages)

 (defun brodyliao/packages-installed-p ()
     (loop for pkg in brodyliao/packages
	   when (not (package-installed-p pkg)) do (return nil)
	   finally (return t)))

 (unless (brodyliao/packages-installed-p)
     (message "%s" "Refreshing package database...")
     (package-refresh-contents)
     (dolist (pkg brodyliao/packages)
       (when (not (package-installed-p pkg))
	 (package-install pkg))))


 ;; Find Executable Path on OS X, for exec-path-from-shell
 (when (memq window-system '(mac ns))
   (exec-path-from-shell-initialize))

(global-hungry-delete-mode)

;;(add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
(smartparens-global-mode t)


;; abo-abo/swiper
(ivy-mode)
(setq ivy-use-virtual-buffers t) 

;; config for js2-mode
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode))
       auto-mode-alist))

(global-company-mode t)

;; Theme
(load-theme 'gruvbox t)

;; pop win
(require 'popwin)
(popwin-mode t)


(provide 'init-packages

	 )
