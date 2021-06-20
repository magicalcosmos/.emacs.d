;; cl - Common Lisp Extension
(require 'cl)

;;optimise loading package
(setq package-archives
    '(("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
      ("org"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
      ("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))

(setq pacakge-check-signature nil)

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
			      js2-refactor
			      web-mode
			      ;; --- Minor Mode ---
			      nodejs-repl
			      exec-path-from-shell
			      reveal-in-osx-finder 	
			      ;; --- Themes ---
			      gruvbox-theme
			      expand-region
			      iedit
			      org-pomodoro
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

(sp-local-pair '(emacs-lisp-mode lisp-interaction-mode) "'" nil :actions nil)

;; web mode
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode))
       '(("\\.jsx\\'" . web-mode))
       '(("\\.html\\'" . web-mode))
       '(("\\.vue\\'" . web-mode))
       auto-mode-alist))

(defun my-web-mode-indent-setup ()
  (setq web-mode-markup-indent-offset 2) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset 2)    ; web-mode, css in html file
  (setq web-mode-code-indent-offset 2)   ; web-mode, js code in html file
  )
(add-hook 'web-mode-hook 'my-web-mode-indent-setup)

(defun my-toggle-web-indent ()
  (interactive)
  ;; web development
  (if (or (eq major-mode 'js-mode) (eq major-mode 'js2-mode))
      (progn
	(setq js-indent-level (if (= js-indent-level 2) 4 2))
	(setq js2-basic-offset (if (= js2-basic-offset 2) 4 2))))

  (if (eq major-mode 'web-mode)
      (progn (setq web-mode-markup-indent-offset (if (= web-mode-markup-indent-offset 2) 4 2))
	     (setq web-mode-css-indent-offset (if (= web-mode-css-indent-offset 2) 4 2))
	     (setq web-mode-code-indent-offset (if (= web-mode-code-indent-offset 2) 4 2))))
  (if (eq major-mode 'css-mode)
      (setq css-indent-offset (if (= css-indent-offset 2) 4 2)))

  (setq indent-tabs-mode nil))

;; js2 refactor
(add-hook 'js2-mode-hook #'js2-refactor-mode)

(require 'org-pomodoro)

(provide 'init-packages)
