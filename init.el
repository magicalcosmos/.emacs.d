(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;; custom function
(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))



;; Package Management
;; -----------------------------------------------------------------
(require 'init-packages)

;; UI Management
;; -----------------------------------------------------------------
(require 'init-ui)


;; Bettter Defaults Management
;; -----------------------------------------------------------------
(require 'init-better-defaults)

;; Keybindings Management
;; -----------------------------------------------------------------
(require 'init-keybindings)

;; Org Management
;; -----------------------------------------------------------------
(require 'init-org)





;;custom file position
(setq custom-file (expand-file-name "lisp/custom.el" user-emacs-directory))

(load-file custom-file)








