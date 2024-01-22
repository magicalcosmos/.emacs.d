
;; Emacs key bindings
(global-set-key (kbd "M-/") 'evilnc-comment-or-uncomment-lines)

(global-set-key (kbd "C-x C-b") 'ibuffer)

;; consult
(global-set-key (kbd "C-s") 'consult-line)
(global-set-key (kbd "M-s i") 'consult-imenu)

(global-set-key (kbd "C-c p f") 'project-find-file)
(global-set-key (kbd "C-c p s") 'consult-grep)
(global-set-key (kbd "C-c r e") 'consult-ripgrep)

;; magit
(bl/leader-key-def
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gd"  'magit-diff-unstaged
  "gc"  'magit-branch-or-checkout
  "gl"   '(:ignore t :which-key "log")
  "glc" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb"  'magit-branch
  "gP"  'magit-push-current
  "gp"  'magit-pull-branch
  "gf"  'magit-fetch
  "gF"  'magit-fetch-all
  "gm"   '(:ignore t :which-key "merge")
  "gmm"  'magit-merge
  "gme"  'magit-merge-editmsg
  "gmn"  'magit-merge-nocommit
  "gmi"  'magit-merge-into
  "gms"  'magit-merge-squash
  "gmp"  'magit-merge-preview
  "gr"  'magit-rebase)


;; lsp-mode
  (general-nmap
    :states 'normal
    "gd" '(lsp-find-definition :wk "jump to the definition")
    "gr" '(lsp-find-references :wk "find all references"))
;; pop ui for selection
  ;; (general-nmap
  ;;   :states 'normal
  ;;   "gd" '(lsp-ui-peek-find-definitions :wk "jump to the definition")
  ;;   "gr" '(lsp-ui-peek-find-references :wk "find all references"))

(provide 'init-keybindings)
