;;; init-java.el --- Java 开发（lsp-java / Eclipse JDT.ls） -*- lexical-binding: t -*-
;;; Commentary:

;; 依赖：JDK 17+、Maven（项目解析）
;; 首次打开 .java 文件时 lsp 会自动下载 Eclipse JDT.ls 服务器

;;; Code:

;; Author: brodyliao

(defun my/find-modern-jdk ()
  "Return a JDK 11+ install directory (the one containing bin/java), or nil.

JDT.ls requires JDK 11+ (lsp-java checks `(>= java-version 9)'), while the
java on PATH here is Oracle JDK 1.8.

Return the *directory*, not the executable: lsp-java builds its probe as
(concat lsp-java-java-path \" -version\") with no quoting, so any path
containing spaces (\"C:/Program Files/...\") makes the shell fail and the
version parse to 1. Keeping the bare name \"java\" and putting this directory
at the front of `exec-path' avoids that."
  (let ((candidates '())
        (roots '("C:/Program Files/Eclipse Adoptium"
                 "C:/Program Files/Java"
                 "D:/Program Files/Java")))
    (dolist (root roots)
      (when (file-directory-p root)
        (dolist (d (directory-files root t directory-files-no-dot-files-regexp))
          ;; 只考虑 JDK（排除 jre），jre 里没有 javac
          (when (string-match-p "\\`jdk-" (file-name-nondirectory d))
            (let ((bin (expand-file-name "bin/" d)))
              (when (file-exists-p (expand-file-name "java.exe" bin))
                (push bin candidates)))))))
    (seq-find (lambda (bin)
                (let ((ver (string-trim
                            (or (ignore-errors
                                  (shell-command-to-string
                                   ;; 加引号，路径含空格
                                   (format "\"%sjava.exe\" -version 2>&1" bin)))
                                ""))))
                  (and (not (string-empty-p ver))
                       (not (string-match-p "\"1\\.[0-8]" ver)))))
              candidates)))

(let ((jdk (my/find-modern-jdk)))
  (if jdk
      ;; `shell-command-to-string' 走 MSYS 的 PATH，与 Emacs 的 exec-path
      ;; 是两套，所以必须改环境变量才能让 java 解析到新版
      (setenv "PATH" (concat jdk path-separator (getenv "PATH")))
    (message "[init-java] 未找到 JDK 11+，JDT.ls 无法启动，gd 将不可用")))

(use-package lsp-java
  :ensure t
  :after lsp-mode
  :config
  ;; 保持默认的裸命令名：defcustom 的绝对路径会被 lsp-java 的版本探测
  ;; 因空格而探测失败。上面的 exec-path 已保证解析到 JDK 11+。
  (add-hook 'java-mode-hook #'lsp-deferred)
  (add-hook 'java-ts-mode-hook #'lsp-deferred))

;; lsp-java 是 lazy 加载的（要等 java-mode-hook 触发），在此之前 M-x 搜不到
;; 它的命令。这里 autoload 两个常用命令，t 表示调用时才加载包，
;; 既让 M-x 能搜到，又不必在启动时拉起 JDT.ls。
(dolist (cmd '(lsp-java-update-project-configuration
               lsp-java-build-project))
  (autoload cmd "lsp-java" nil t))

(provide 'init-java)
