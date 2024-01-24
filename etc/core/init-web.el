;;; init-web.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

(use-package web-mode
:ensure t
:commands web-mode
:mode (
  ("\\.html?\\'" . web-mode)
  ("\\.tsx?\\'" . web-mode);;  会自动格式化，有问题
  ("\\.jsx?\\'" . web-mode)
  ("\\.vue?\\'" . web-mode)
  ;; ("\\.scss\\'" . web-mode)
  ;; ("\\.css\\'" . web-mode)
  ("\\.json\\'" . web-mode)
)
:config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-script-padding 2)
  (setq web-mode-block-padding 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-comment-style 2)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-enable-block-face t)
  (setq web-mode-enable-part-face nil)
  (setq web-mode-enable-comment-interpolation t)
  (setq web-mode-enable-heredoc-fontification t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-enable-auto-indentation nil)
  (local-set-key (kbd "RET") 'newline-and-indent)

;; typescript
   (setq web-mode-attr-indent-offset nil)
   (setq web-mode-tag-auto-close-style 2)
   (setq web-mode-enable-auto-closing t)
   (setq tab-width 2)
   


  (setq web-mode-engines-alist '(("django"    . "\\.html\\'")))
  (setq web-mode-ac-sources-alist 
    '(("css" . (ac-source-css-property ac-source-emmet-css-snippets))
      ("scss" . (ac-source-css-property ac-source-emmet-css-snippets))
      ("vue" . (ac-source-words-in-buffer ac-source-abbrev))
      ("html" . (ac-source-words-in-buffer ac-source-abbrev ac-source-emmet-html-aliases ac-source-emmet-html-snippets))))
  (setq web-mode-enable-engine-detection t)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-close-style t)
  (setq web-mode-enable-auto-quoting t) ; this fixes the quote problem I mentioned
  (add-hook 'css-mode-hook
      (lambda ()
        (setq css-indent-offset 2)
      )
  )
)

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(provide 'init-web)
