;;; init-java.el --- Java 开发（lsp-java / Eclipse JDT.ls） -*- lexical-binding: t -*-
;;; Commentary:

;; 依赖：JDK 17+、Maven（项目解析）
;; 首次打开 .java 文件时 lsp 会自动下载 Eclipse JDT.ls 服务器

;;; Code:

;; Author: brodyliao

(use-package lsp-java
  :ensure t
  :after lsp-mode
  :config
  (add-hook 'java-mode-hook #'lsp-deferred)
  (add-hook 'java-ts-mode-hook #'lsp-deferred))

(provide 'init-java)
