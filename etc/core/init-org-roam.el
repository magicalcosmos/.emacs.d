(use-package org-roam
  :straight t
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/Notes/Roam/")
  (org-roam-completion-everywhere t)
  (org-roam-completion-system 'default)
  (org-roam-capture-templates
    '(("d" "default" plain
       #'org-roam-capture--get-point
       "%?"
       :file-name "%<%Y%m%d%H%M%S>-${slug}"
       :head "#+title: ${title}\n"
       :unnarrowed t)
      ("ll" "link note" plain
       #'org-roam-capture--get-point
       "* %^{Link}"
       :file-name "Inbox"
       :olp ("Links")
       :unnarrowed t
       :immediate-finish)
      ("lt" "link task" entry
       #'org-roam-capture--get-point
       "* TODO %^{Link}"
       :file-name "Inbox"
       :olp ("Tasks")
       :unnarrowed t
       :immediate-finish)))
  (org-roam-dailies-directory "Journal/")
  (org-roam-dailies-capture-templates
    '(("d" "default" entry
       #'org-roam-capture--get-point
       "* %?"
       :file-name "Journal/%<%Y-%m-%d>"
       :head "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")
      ("t" "Task" entry
       #'org-roam-capture--get-point
       "* TODO %?\n  %U\n  %a\n  %i"
       :file-name "Journal/%<%Y-%m-%d>"
       :olp ("Tasks")
       :empty-lines 1
       :head "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")
      ("j" "journal" entry
       #'org-roam-capture--get-point
       "* %<%I:%M %p> - Journal  :journal:\n\n%?\n\n"
       :file-name "Journal/%<%Y-%m-%d>"
       :olp ("Log")
       :head "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")
      ("l" "log entry" entry
       #'org-roam-capture--get-point
       "* %<%I:%M %p> - %?"
       :file-name "Journal/%<%Y-%m-%d>"
       :olp ("Log")
       :head "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")
      ("m" "meeting" entry
       #'org-roam-capture--get-point
       "* %<%I:%M %p> - %^{Meeting Title}  :meetings:\n\n%?\n\n"
       :file-name "Journal/%<%Y-%m-%d>"
       :olp ("Log")
       :head "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")))
  :bind (:map org-roam-mode-map
          (("C-c n l"   . org-roam)
           ("C-c n f"   . org-roam-find-file)
           ("C-c n d"   . org-roam-dailies-find-date)
           ("C-c n c"   . org-roam-dailies-capture-today)
           ("C-c n C r" . org-roam-dailies-capture-tomorrow)
           ("C-c n t"   . org-roam-dailies-find-today)
           ("C-c n y"   . org-roam-dailies-find-yesterday)
           ("C-c n r"   . org-roam-dailies-find-tomorrow)
           ("C-c n g"   . org-roam-graph))
         :map org-mode-map
         (("C-c n i" . org-roam-insert))
         (("C-c n I" . org-roam-insert-immediate))))

(provide 'init-org-roam)