(use-package org
  :hook (org-mode . visual-line-mode)
  :bind (("C-c o c" . counsel-org-capture)
         ("C-c o a" . org-agenda)
         :map org-mode-map
         ("M-<left>" . nil)
         ("M-<right>" . nil)
         ("C-c c" . #'org-mode-insert-code)
         ("C-c a f" . #'org-shifttab)
         ("C-c a S" . #'zero-width))
  :custom
  (org-adapt-indentation nil)
  (org-directory "~/txt")
  (org-default-notes-file (concat org-directory "/notes.org"))
  (org-return-follows-link t)
  (org-src-ask-before-returning-to-edit-buffer nil "org-src is kinda needy out of the box")
  (org-src-window-setup 'current-window)
  (org-agenda-files (list (concat org-directory "/agenda.org")))

  :config
  (defun pt/org-mode-hook ()
    (when (s-suffix? "todo.org" (buffer-file-name (current-buffer)))
      (real-auto-save-mode)))
  (defun make-inserter (c) '(lambda () (interactive) (insert-char c)))
  (defun zero-width () (interactive) (insert "​"))

  (defun org-mode-insert-code ()
    "Like markdown-insert-code, but for org instead."
    (interactive)
    (org-emphasize ?~)))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package org-ref
  :disabled ;; very slow to load
  :config (defalias 'dnd-unescape-uri 'dnd--unescape-uri))

(use-package org-roam
  :bind
  (("C-c o r" . org-roam-capture)
   ("C-c o f" . org-roam-node-find))
  :custom
  (org-roam-directory (expand-file-name "~/Dropbox/txt/roam"))
  (org-roam-v2-ack t)
  :config
  (org-roam-db-autosync-mode))

(provide 'init-org)
