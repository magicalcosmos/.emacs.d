
;; (use-package eaf
;;   :defer t
;;   :load-path "~/.emacs.d/etc/emacs-application-framework"
;;   :custom
;;   ; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
;;   (eaf-browser-continue-where-left-off t)
;;   (eaf-browser-enable-adblocker t)
;;   (browse-url-browser-function 'eaf-open-browser)
;;   :config
;;   (defalias 'browse-web #'eaf-open-browser)
;;   (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
;;   (eaf-bind-key take_photo "p" eaf-camera-keybinding)
;;   (eaf-bind-key nil "M-q" eaf-browser-keybinding)) ;; unbind, see more in the Wiki
;; (require 'eaf-music-player)
;; (require 'eaf-js-video-player)
;; (require 'eaf-terminal)
;; (require 'eaf-image-viewer)
;; (require 'pdf-viewer)
;;   (require 'eaf-browser)
;;   (require 'eaf-map)
;;   (require 'eaf-markdown-previewer)
;;   (require 'eaf-video-player)
;;   (require 'eaf-org-previewer)
;;   (require 'eaf-netease-cloud-music)
;;   (require 'eaf-markmap)


(use-package quelpa-use-package)
;; Don't forget to run M-x eaf-install-dependencies
(use-package eaf
  :defer t
  :demand t
  :quelpa (eaf :fetcher github
              :repo  "manateelazycat/emacs-application-framework"
              :files ("*"))
  :load-path "~/.emacs.d/etc/emacs-application-framework" ; Set to "/usr/share/emacs/site-lisp/eaf" if installed from AUR
  :init
  (use-package epc      :defer t :ensure t)
  (use-package ctable   :defer t :ensure t)
  (use-package deferred :defer t :ensure t)
  (use-package s        :defer t :ensure t)
  (setq browse-url-browser-function 'eaf-open-browser))

(require 'eaf)
(require 'eaf-pdf-viewer)

(add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex --synctex=1%(mode)%' %t" TeX-run-TeX nil t))
(add-to-list 'TeX-view-program-list '("eaf" eaf-pdf-synctex-forward-view))
(add-to-list 'TeX-view-program-selection '(output-pdf "eaf"))


(provide 'init-eaf)