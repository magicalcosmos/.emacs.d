;; great for programmers
(use-package format-all :ensure t :defer t
  ;; 开启保存时自动格式化
  :hook (prog-mode . format-all-mode)
  ;; 绑定一个手动格式化的快捷键
  :bind ("C-c f" . #'format-all-region-or-buffer))

  (provide 'init-format-all)