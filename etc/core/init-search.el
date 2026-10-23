;;; init-search.el --- 项目全局搜索（ripgrep / ag / git grep） -*- lexical-binding: t -*-
;;; Commentary:

;; 三种搜索后端，各有用途：
;;
;;   consult-ripgrep   ripgrep。默认忽略 .gitignore 里的文件（node_modules、
;;                     dist、out 等自动跳过），非 git 目录也能用，最通用。
;;   consult-git-grep  git grep。只搜被 git 跟踪的文件，比 rg 更快
;;                     （git 已经知道哪些文件被跟踪，不必遍历目录树）。
;;                     实测 gxrcub_pc（1228 个文件）：git grep 264ms，
;;                     ag 1404ms。
;;   ag / rgrep        命令行层面的搜索。ag 是银搜索器，比 grep 快，
;;                     Windows 上没有 grep，所以把 grep-program 指向它。
;;
;; 用法：
;;   C-c s r   consult-ripgrep（项目全局搜索，默认）
;;   C-c s g   consult-git-grep（只搜 git 跟踪的文件，更快）
;;   C-c s a   consult-ag（银搜索器）
;;   M-.       rgrep（Emacs 内置 grep 循环，已指向 ag）
;;
;; 装 ripgrep / ag：choco install ripgrep ag
;; 两者都在 %ProgramData%\chocolatey\bin，Emacs 启动时 PATH 里已有。

;;; Code:

(require 'consult)

(defgroup my/search nil
  "项目全局搜索。"
  :group 'tools)

;; --- 搜索工具路径 ----------------------------------------------------------
;; rg / ag 装在 chocolatey 的 bin 目录，Windows 上 PATH 里已有，
;; 但显式指定更稳（不依赖启动环境）。
(defcustom my/search-ripgrep-program "rg"
  "ripgrep 可执行文件名。"
  :type 'string
  :group 'my/search)

(defcustom my/search-ag-program "ag"
  "ag（the_silver_searcher）可执行文件名。"
  :type 'string
  :group 'my/search)

;; 内置的 grep.el 用 grep-program 决定 grep/rgrep 调什么。Windows 上没有
;; grep，M-x rgrep 会直接失败；指向 ag 后它就能用了。
(defcustom my/search-grep-program "ag"
  "grep.el 使用的搜索程序。Windows 上无 grep，用 ag 代替。"
  :type 'string
  :group 'my/search)

;; --- consult 搜索参数 ------------------------------------------------------
;; consult-ripgrep-args / consult-git-grep-args 是命令行参数字符串，
;; 动态参数（搜索词、路径）会追加在后面。
(defcustom my/search-rg-args
  "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --with-filename --line-number --hidden --glob !.git/*"
  "consult-ripgrep 使用的 ripgrep 参数。
--hidden 让它也搜 .gitignore 忽略的隐藏文件（但排除 .git 目录本身）。
rg 默认已按 .gitignore 过滤，node_modules / dist / out 不会出现在结果里。"
  :type 'string
  :group 'my/search)

(defcustom my/search-git-grep-args
  "git --no-pager grep --null --color=never --ignore-case --extended-regexp --line-number -I"
  "consult-git-grep 使用的 git grep 参数。
只搜被 git 跟踪的文件，在 git 仓库里比 rg 更快。"
  :type 'string
  :group 'my/search)

(defcustom my/search-ag-args
  "--vimgrep --smart-case --ignore-case --hidden"
  "consult-ag 使用的 ag 参数。
注意：不要加 --norecurse（ag 就不再递归子目录，等于搜不到东西），也不要加
--skip .git（ag 的 Windows 版在该选项后会错位，把后面的 pattern 当成目录）。
.git 目录由 ag 自身忽略。"
  :type 'string
  :group 'my/search)

(eval-after-load 'consult
  (progn
    (setq consult-ripgrep-args my/search-rg-args
          consult-git-grep-args my/search-git-grep-args)
    ;; consult-git-grep-args 等是 defcustom，直接 setq 也生效
    ))

;; --- 让内置命令用上 rg / ag -----------------------------------------------
(eval-after-load 'grep
  (setq grep-program my/search-grep-program
        grep-command my/search-ag-program
        rgrep-command my/search-ag-program))

;; rg-program 属于 rg 包（未安装）；consult-ripgrep 直接调 `rg` 命令，
;; 靠 PATH 解析。装上 rg 包时把 rg-program 也指向同一个可执行文件。
(when (boundp 'rg-program)
  (setq rg-program my/search-ripgrep-program))

;; --- consult-ag ------------------------------------------------------------
;; consult 自带 consult-ripgrep / consult-git-grep，但不带 ag 版本，
;; 这里用 consult--grep 的通用接口自己接一个。
;;
;; ag 与 rg 的命令行语法不同：ag 的 pattern 是位置参数（不支持 rg 的
;; `-e PATTERN`），也只支持 POSIX ERE（不支持 `-P`）。所以这里不能用
;; consult--ripgrep-make-builder 那套（它会按 rg 的习惯加 -e 和 -P），
;; 要自己拼。
(defun consult--ag-make-builder (paths)
  "Create ag command line builder given PATHS."
  (let* ((cmd (cons my/search-ag-program
                    (split-string my/search-ag-args " ")))
         (type 'extended))
    (lambda (input)
      (pcase-let* ((`(,arg . ,opts) (consult--command-split input))
                   (flags (append cmd opts))
                   (ignore-case
                    (and (not (or (member "-s" flags) (member "--case-sensitive" flags)))
                         (or (member "-i" flags) (member "--ignore-case" flags)
                             (and (or (member "-S" flags) (member "--smart-case" flags))
                                  (let (case-fold-search)
                                    (not (string-match-p "[[:upper:]]" arg))))))))
        ;; ag 的语法是 `ag [OPTIONS] PATTERN [PATH...]`，pattern 与 path 都是
        ;; 位置参数，顺序不能颠倒。
        (if (or (member "-F" flags) (member "--fixed-strings" flags))
            (cons (append cmd (list arg) paths opts)
                  (apply-partially #'consult--highlight-literals arg ignore-case))
          (pcase-let ((`(,re ,hl) (consult--compile-regexp arg type ignore-case)))
            (when re
              (cons (append cmd (list (consult--join-regexps re type)) paths opts)
                    hl))))))))

;;;###autoload
(defun consult-ag (&optional dir initial)
  "Search with `ag' for files in DIR with INITIAL input.
See `consult-grep' for details."
  (interactive "P")
  (consult--grep "The Silver Searcher" #'consult--ag-make-builder dir initial))

;; --- 快捷键 ----------------------------------------------------------------
;; C-c s 前缀：r=ripgrep（默认）, g=git grep, a=ag
(define-key global-map (kbd "C-c s r") #'consult-ripgrep)
(define-key global-map (kbd "C-c s g") #'consult-git-grep)
(define-key global-map (kbd "C-c s a") #'consult-ag)
(define-key global-map (kbd "C-c s p") #'project-search)

(provide 'init-search)

;;; init-search.el ends here
