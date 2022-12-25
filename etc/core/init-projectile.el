;; (defun bl/switch-project-action ()
;;   "Open latest edited buffer when switched the  exist project, find files when switched to a new project."
;;   (if  (null (projectile-project-buffer-files ))
;;     (projectile-find-file)
;;     (switch-to-buffer (get-buffer (car (projectile-project-buffer-files)))))
;; )

;; (defvar +quick-switch-buffer-hook nil)
;; (defun switch-to-previous-buffer ()
;;   "Switch to previously open buffer.
;; Repeated invocations toggle between the two most recently open buffers."
;;   (interactive)
;;   (switch-to-buffer (other-buffer (current-buffer) 1))
;;   (run-hook-with-args-until-success '+quick-switch-buffer-hook))

;; (defun delete-file-and-buffer ()
;;   "Kill the current buffer and deletes the file it is visiting."
;;   (interactive)
;;   (let ((filename (buffer-file-name)))
;;     (when filename
;;       (if (vc-backend filename)
;;           (vc-delete-file filename)
;;         (progn
;;           (delete-file filename)
;;           (message "Deleted file %s" filename)
;;           (kill-buffer))))))


;; (use-package projectile
;;   :ensure projectile t
;;   :init
;;   (setq projectile-cache-file (concat CACHE-DIR "projectile.cache"))
;;   (setq projectile-known-projects-file (concat CACHE-DIR "projectile-bookmarks.eld"))
;;   (defvar projectile-mode-line)
;;   (setq projectile-completion-system 'ivy)
;;   ;; (setq projectile-enable-caching t) ;; Projectile turbo!!
;;   :config
;;   (defun +copy-project-file-name()
;;     (interactive)
;;     (let ((filename (file-relative-name buffer-file-name (projectile-project-root))))
;;       (when filename
;;         (kill-new filename)
;;         (message "Copied project file name '%s' to the clipboard." filename))))
;;   ;; (projectile-load-known-projects)
;;   (setq projectile-mode-line-prefix "")
;;   (projectile-mode 1)
;;   :bind (("C-c p z" . counsel-fzf)
;;          ("C-c p w" . +copy-project-file-name)
;;          ("C-c p k" . projectile-kill-buffers)
;;          ("C-c p c" . projectile-compile-project)
;;          ("C-c p s" . projectile-save-project-buffers)))


(use-package counsel-projectile
  :defer 1
  :bind (("C-c p f" . counsel-projectile-find-file)
         ("C-c p b" . counsel-projectile-switch-to-buffer)
         ("C-x B" . counsel-projectile-switch-to-buffer)
         ("C-c p p" . counsel-projectile-switch-project))
  :init
  (setq counsel-projectile-switch-project-action
        '(1
          ("o" counsel-projectile-switch-project-action "jump to a project buffer or file")
          ("f" counsel-projectile-switch-project-action-find-file "jump to a project file")
          ("d" counsel-projectile-switch-project-action-find-dir "jump to a project directory")
          ("D" counsel-projectile-switch-project-action-dired "open project in dired")
          ("b" counsel-projectile-switch-project-action-switch-to-buffer "jump to a project buffer")
          ("m" counsel-projectile-switch-project-action-find-file-manually "find file manually from project root")
          ("S" counsel-projectile-switch-project-action-save-all-buffers "save all project buffers")
          ("k" counsel-projectile-switch-project-action-kill-buffers "kill all project buffers")
          ("K" counsel-projectile-switch-project-action-remove-known-project "remove project from known projects")
          ("c" counsel-projectile-switch-project-action-compile "run project compilation command")
          ("C" counsel-projectile-switch-project-action-configure "run project configure command")
          ("E" counsel-projectile-switch-project-action-edit-dir-locals "edit project dir-locals")
          ("v" counsel-projectile-switch-project-action-vc "open project in vc-dir / magit / monky")
          ("s" counsel-projectile-switch-project-action-rg "search project with rg")
          ("x" counsel-projectile-switch-project-action-run-vterm "invoke vterm from project root")))

  ;; Default counsel-projectile is very slow. Removing it's usage when switching project
  (advice-add 'counsel-projectile-switch-project-action :override 'counsel-projectile-switch-project-action-find-file))

;; (use-package "+projectile-find-file"
;;   :ensure nil
;;   :bind ("M-p" . +projectile-find-file-dynamic)
;;   :config

;;   (eval-after-load "all-the-icons-ivy"
;;     '(progn (let ((all-the-icons-ivy-file-commands
;;                    '(counsel-projectile
;;                      counsel-projectile-find-file
;;                      +projectile-find-file-dynamic
;;                      +projectile-find-file
;;                      counsel-projectile-find-dir)))
;;               (all-the-icons-ivy-setup))
;;             ))

;;   (advice-add 'counsel-projectile-find-file :override '+projectile-find-file-dynamic))

;; (require 'counsel-projectile)

  (global-set-key (kbd "M-p") #'counsel-projectile-find-file)
  (global-set-key (kbd "C-c p f") #'fzf)
  (global-set-key (kbd "C-c a") #'counsel-ag)
  (global-set-key (kbd "C-c s") #'counsel-rg)

;; (use-package project
;;   :ensure nil
;;   :config
;;   (setq project-list-file (concat CACHE-DIR "projects")))


;;   ;; (use-package counsel-projectile
;;   ;;   :ensure t)

;; (defun add-or-switch-project-dwim (dir)
;;   "Let elisp do a few chores & set my hands free!"
;;   (interactive (list (read-directory-name "Add to known projects: ")))
;;   (projectile-add-known-project dir)
;;   (find-file dir)
;;   (treemacs-add-and-display-current-project))



(provide 'init-projectile)
