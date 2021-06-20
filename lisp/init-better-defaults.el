(setq ring-bell-function 'ignore)

;; auto update file
(global-auto-revert-mode t )

;; line number
(global-linum-mode t)

;; rename confirm
(fset 'yes-or-no-p 'y-or-n-p)

;; selection mode, can replace word
(delete-selection-mode t) 

;;abbrev
(setq-default abbrev-mode t)
(define-abbrev-table 'global-abbrev-table '(
					    ;; Shifu
					    ("blp" "brodyliao/packages")
					    ;; Tudi
					    ("8lxy" "lixinyang")
					    ))

;; remove back up
(setq make-backup-files nil)
(setq auto-save-default nil)

;; recentf
(recentf-mode 1)
(setq recentf-max-menu-item 25)

;; highlight in range of paren
(define-advice show-paren-function (:around (fn) fix-show-paren-function)
  "Highlight enclosing parens."
  (cond ((looking-at-p "\\s(") (funcall fn))
	(t (save-excursion
	     (ignore-errors (backward-up-list))
	     (funcall fn)))))


;; replace special char
(defun remove-dos-eol ()
  "Replace DOS eolns CR LF with Unix eolns CR"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))


;; hide special char
;;(defun hidden-dos-eol ()
;;  "Do not show ^M in files containing mixed UNIX and DOS line endings."
;;  (interactive)
;;  (unless buffer-display-table
;;    (setq buffer-display-table (make-display-table)))
;;  (aset buffer-display-table ?\^M []))


 
;; show match parents
(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)


(defun indent-buffer()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer()
  (interactive)
  (save-excursion
    (if (region-active-p)
	(progn
	  (indent-region (region-beginning) (region-end))
	  (message "Indent selected region."))
      (progn
	(indent-buffer)
	(message "Indent buffer.")))))


(setq hippie-expand-try-function-list '(try-expand-debbrev
					try-expand-debbrev-all-buffers
					try-expand-debbrev-from-kill
					try-complete-file-name-partially
					try-complete-file-name
					try-expand-all-abbrevs
					try-expand-list
					try-expand-line
					try-complete-lisp-symbol-partially
					try-complete-lisp-symbol))



(put 'dired-find-alternate-file 'disabled nil)


;; delete file and children
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

(require 'dired-x)
(setq dired-dwim-target t)



(defun occur-dwim ()
  "Call `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
	    (buffer-substring-no-properties
	     (region-beginning)
	     (region-end))
	  (let ((sym (thing-at-point 'symbol)))
	    (when (stringp sym)
	      (regexp-quote sym))))
	regexp-history)
  (call-interactively 'occur))
(global-set-key (kbd "M-s o") 'occur-dwim)



(defun js2-imenu-make-index ()
      (interactive)
      (save-excursion
	;; (setq imenu-generic-expression '((nil "describe\\(\"\\(.+\\)\"" 1)))
	(imenu--generic-function '(("describe" "\\s-*describe\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				   ("it" "\\s-*it\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				   ("test" "\\s-*test\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				   ("before" "\\s-*before\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				   ("after" "\\s-*after\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
				   ("Function" "function[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*(" 1)
				   ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
				   ("Function" "^var[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
				   ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*()[ \t]*{" 1)
				   ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*:[ \t]*function[ \t]*(" 1)
				   ("Task" "[. \t]task([ \t]*['\"]\\([^'\"]+\\)" 1)))))
(add-hook 'js2-mode-hook
	      (lambda ()
		(setq imenu-create-index-function 'js2-imenu-make-index)))

(global-set-key (kbd "M-s i") 'counsel-imenu)

(set-language-environment "UTF-8")

(defun brodyliao/insert-chrome-current-tab-url()
  (interactive)
  (insert (brodyliao/retrieve-chrome-current-tab-url)))

(defun brodyliao/retrieve-chrome-current-tab-url()
  "Get the URL of the active tab of the first window"
  (interactive)
      (let ((result (do-applescript
		     (concat
		      "set frontmostApplication to path to frontmost application\n"
		      "tell application \"Google Chrome\"\n"
		      " set theUrl to get URL of active tab of first window\n"
		      " set theResult to (get theUrl) \n"
		      "end tell\n"
		      "activate application (frontmostApplication as text)\n"
		      "set links to {}\n"
		      "copy theResult to the end of links\n"
		      "return links as string\n"))))
	(format "%s" (s-chop-suffix "\"" (s-chop-prefix "\"" result)))))



(provide 'init-better-defaults)
