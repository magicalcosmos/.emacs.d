(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
          :map ivy-minibuffer-map
          ("TAB" . ivy-alt-done)
          ("C-l" . ivy-alt-done)
          ("C-j" . ivy-next-line)
          ("C-k" . ivy-previous-line)
          :map ivy-switch-buffer-map
          ("C-k" . ivy-previous-line)
          ("C-l" . ivy-done)
          ("C-d" . ivy-switch-buffer-kill)
          :map ivy-reverse-i-search-map
          ("C-k" . ivy-previous-line)
          ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-wrap t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)

  ;; Use different regex strategies per completion command
  (push '(completion-at-point . ivy--regex-fuzzy) ivy-re-builders-alist) ;; This doesn't seem to work...
  (push '(swiper . ivy--regex-ignore-order) ivy-re-builders-alist)
  (push '(counsel-M-x . ivy--regex-ignore-order) ivy-re-builders-alist)

  ;; Set minibuffer height for different commands
  (setf (alist-get 'counsel-projectile-ag ivy-height-alist) 15)
  (setf (alist-get 'counsel-projectile-rg ivy-height-alist) 15)
  (setf (alist-get 'swiper ivy-height-alist) 15)
  (setf (alist-get 'counsel-switch-buffer ivy-height-alist) 7))


(use-package ivy-hydra
  :defer t
  :after hydra)

(use-package use-package-hydra
  :ensure t
  :after hydra) 

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :ensure t
  :init (ivy-rich-mode 1))
;; Whether display the colorful icons.
;; It respects `all-the-icons-color-icons'.
(setq all-the-icons-ivy-rich-color-icon t)

;; The icon size
(setq all-the-icons-ivy-rich-icon-size 1.0)

;; Whether support project root
(setq all-the-icons-ivy-rich-project t)

;; Definitions for ivy-rich transformers.
;; See `ivy-rich-display-transformers-list' for details."
all-the-icons-ivy-rich-display-transformers-list

;; Slow Rendering
;; If you experience a slow down in performance when rendering multiple icons simultaneously,
;; you can try setting the following variable
(setq inhibit-compacting-font-caches t)
;; set icons
(defun ivy-rich-switch-buffer-icon (candidate)
  (with-current-buffer
      (get-buffer candidate)
    (let ((icon (all-the-icons-icon-for-mode major-mode)))
      (if (symbolp icon)
          (all-the-icons-icon-for-mode 'fundamental-mode)
        icon))))
(setq ivy-rich-display-transformers-list
      '(ivy-switch-buffer
        (:columns
          ((ivy-rich-switch-buffer-icon (:width 2))
          (ivy-rich-candidate (:width 30))
          (ivy-rich-switch-buffer-size (:width 7))
          (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
          (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
          (ivy-rich-switch-buffer-project (:width 15 :face success))
          (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
          :predicate
          (lambda (cand) (get-buffer cand)))))
(use-package ivy-xref
:ensure t
:init
;; xref initialization is different in Emacs 27 - there are two different
;; variables which can be set rather than just one
(when (>= emacs-major-version 27)
(setq xref-show-definitions-function #'ivy-xref-show-defs))
;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
;; commands other than xref-find-definitions (e.g. project-find-regexp)
;; as well
(setq xref-show-xrefs-function #'ivy-xref-show-xrefs))
;; swiper
(use-package swiper
:ensure t
:bind (
  ("C-r" . swiper-isearch)
  ("C-c C-r" . ivy-resume)
  ("C-c C-o" . ivy-occur)
  ("C-c f" . counsel-recentf)
  ("C-c g" . counsel-git)
  ("C-c j" . counsel-git-grep)
  ("C-c k" . counsel-ag)
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file))
:config
(progn
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-display-style 'fancy)
  (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
  ))

(bl/leader-key-def
"r"   '(ivy-resume :which-key "ivy resume")
"f"   '(:ignore t :which-key "files")
"ff"  '(counsel-find-file :which-key "open file")
"C-f" 'counsel-find-file
"fr"  '(counsel-recentf :which-key "recent files")
"fR"  '(revert-buffer :which-key "revert file")
"fj"  '(counsel-file-jump :which-key "jump to file"))

(provide 'init-swiper-ivy-counsel)