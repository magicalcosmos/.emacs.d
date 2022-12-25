(use-package web-mode
:ensure t
:commands web-mode
:mode (
  ("\\.html?\\'" . web-mode)
  ("\\.jsx?\\'" . web-mode)
  ("\\.tsx?\\'" . web-mode)
  ("\\.vue?\\'" . web-mode)
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


  (setq web-mode-engines-alist '(("django"    . "\\.html\\'")))
  (setq web-mode-ac-sources-alist 
    '(("css" . (ac-source-css-property))
      ("vue" . (ac-source-words-in-buffer ac-source-abbrev))
      ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
  (setq web-mode-enable-engine-detection t)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-quoting t) ; this fixes the quote problem I mentioned
  (add-hook 'css-mode-hook
      (lambda ()
        (setq css-indent-offset 2)
      )
  )
)

;; 附加 Web 开发的各种插件
(defun web-dev-attached ()
  ;; 设置关闭自动换行
  (setq truncate-lines t)
  ;; 开启显示行号
  (display-line-numbers-mode +1)
  ;; 启动行号左侧对齐，并且不随着宽度变化而变化
  (setq display-line-numbers-width-start t)
  ;; 开启代码折叠子模式
  (origami-mode t)
  (hs-minor-mode t)
  ;; 设置列参考线：120
  (setq display-fill-column-indicator-column 120)
  (display-fill-column-indicator-mode t)
  ;; 开启代码折叠快捷键
  (define-key hs-minor-mode-map (kbd "C-c C-f") 'hs-toggle-hiding))

(use-package json-mode
  :defer 3
  :mode "\\.json\\'"
  :config
  (add-hook 'json-mode-hook
            (lambda ()
              ;; 设置自动缩进的宽度
              (make-local-variable 'js-indent-level)
              (setq js-indent-level 2)
              ;; 其它开发设置
              (web-dev-attached))))
              
(setq-default css-indent-offset 2)

(provide 'init-web)
