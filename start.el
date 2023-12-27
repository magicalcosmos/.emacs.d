;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

;;在文件最开头添加地个 文件作用域的变量设置，设置变量的绑定方式
;; -*- lexical-binding: t -*-
	
(push "~/.emacs" load-path)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(add-to-list 'load-path "~/.emacs.d/straight")

;; Use straight.el for use-package expressions
(straight-use-package 'use-package)

(require 'cc-mode)
;; Speed up startup
(setq auto-mode-case-fold nil)

(unless (or (daemonp) noninteractive)
  (let ((old-file-name-handler-alist file-name-handler-alist))
    ;; If `file-name-handler-alist' is nil, no 256 colors in TUI
    ;; @see https://emacs-china.org/t/spacemacs-centaur-emacs/3802/839
    (setq file-name-handler-alist
          (unless (display-graphic-p)
            '(("\\(?:\\.tzst\\|\\.zst\\|\\.dz\\|\\.txz\\|\\.xz\\|\\.lzma\\|\\.lz\\|\\.g?z\\|\\.\\(?:tgz\\|svgz\\|sifz\\)\\|\\.tbz2?\\|\\.bz2\\|\\.Z\\)\\(?:~\\|\\.~[-[:alnum:]:#@^._]+\\(?:~[[:digit:]]+\\)?~\\)?\\'" . jka-compr-handler))))
    (add-hook 'emacs-startup-hook
              (lambda ()
                "Recover file name handlers."
                (setq file-name-handler-alist
                      (delete-dups (append file-name-handler-alist
                                           old-file-name-handler-alist)))))))

;; (setq gc-cons-threshold most-positive-fixnum
;;       gc-cons-percentage 0.5)

;; (let ((normal-gc-cons-threshold (* 20 1024 1024))
;;       (init-gc-cons-threshold (* 128 1024 1024)))
;;   (setq gc-cons-threshold init-gc-cons-threshold)
;;   (add-hook 'emacs-startup-hook
;;             (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

;; (setq gc-cons-threshold 100000000)
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000)))


;; Use spotlight search backend as a default for M-x locate (and helm/ivy
;; variants thereof), since it requires no additional setup.
(setq locate-command "mdfind")


;;
;;; Compatibilty fixes

;; Curse Lion and its sudden but inevitable fullscreen mode!
;; NOTE Meaningless to railwaycat's emacs-mac build
(setq ns-use-native-fullscreen nil)

;; Visit files opened outside of Emacs in existing frame, not a new one
(setq ns-pop-up-frames nil)


;; Prevent unwanted runtime compilation for gccemacs (native-comp) users;
;; packages are compiled ahead-of-time when they are installed and site files
;; are compiled when gccemacs is installed.
;; REVIEW Remove after a month
(setq comp-deferred-compilation nil
      native-comp-deferred-compilation nil)

;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent the use of stale byte-code. Otherwise, it saves us a little IO time
;; to skip the mtime checks on every *.elc file.
(setq load-prefer-newer noninteractive)

;; In Emacs 27+, package initialization occurs before `user-init-file' is
;; loaded, but after `early-init-file'. Doom handles package initialization, so
;; we must prevent Emacs from doing it early!
(setq package-enable-at-startup nil)

(setq inhibit-startup-message t)
(setq initial-buffer-choice  nil)
(setq inhibit-compacting-font-caches t)

;; 开启 TCP 连接到 Server
(setq server-use-tcp t)

;; 直接打开软链接地址的文件，而不是打开原始文件的地址
(setq vc-follow-symlinks nil)

;; 设置自动加载已修改文件
(global-auto-revert-mode t)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)


;; 设置弹窗窗口出现纵向分隔的极限值：这个值能在 Mac 1440 分辨率下仍然以上下的方式分隔弹出窗口
(setq split-width-threshold 180)

;; 设置 Emacs 的缺省工作路径
(setq default-directory "~/")

;; Newline at end of file
(setq require-final-newline t)

;; 设置选中时编辑直接删除选中值
(delete-selection-mode t)


;; 设置光标样式
(setq-default cursor-type 'bar)

;; 自动补全括号
(electric-pair-mode t)    
;; 编程模式下，光标在括号上时高亮另一个括号                   
(add-hook 'prog-mode-hook #'show-paren-mode) 
;; 在 Mode line 上显示列号
(column-number-mode t)
;; 选中文本后输入文本会替换文本（更符合我们习惯了的其它编辑器的逻辑）                       
(delete-selection-mode t)
;; 编程模式下，可以折叠代码块                    
(add-hook 'prog-mode-hook #'hs-minor-mode)   
;; 图形界面时关闭滚动条
(when (display-graphic-p) (toggle-scroll-bar -1)) 
;; 为选中的代码加注释/去注释
(global-set-key (kbd "C-c '") 'comment-or-uncomment-region) 


;; remove cl warning
(setq byte-compile-warnings '(cl-functions))

;; Disable visible scrollbar
(scroll-bar-mode -1)

;; Dis able the toolbar
(tool-bar-mode -1)

(show-paren-mode 1)

;; give some breathing room
(set-fringe-mode 10)

;; Diable the menu bar
(menu-bar-mode -1)

;; set up the visiable bell
(setq visible-bell t)

;; yes to y, no to n
(fset 'yes-or-no-p 'y-or-n-p)

;; 缓解在快速移动时大量代码的语法高亮
(setq redisplay-skip-fontification-on-input t)

;; buffer to right
; (setq split-width-threshold nil)
;
; (global-set-key (kbd "C-x C-b")
;                 (lambda ()
;                         (interactive)
;                         (let ((display-buffer-overriding-action ;; force window
;                                                                 '((display-buffer-reuse-window
;                                                                    display-buffer-same-window)
;                                                                   (inhibit-same-window . nil))))
;                           (split-window-horizontally) ;; split window
;                           (other-window 1) ;; change it
;                           (list-buffers))))

;; ESC Cancels All
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; set realtive numbers
(display-line-numbers-mode t)

;; set type of line numbering (global variable)
(setq display-line-numbers-type 'relative)

;; activate line numbering in all buffers/modes
(global-display-line-numbers-mode 1)

;; Activate line numbering in programming modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(global-hl-line-mode 1)

(delete-selection-mode t)

;; 错误时的“哔哔”的警告提示音
(setq ring-bell-function 'ignore)

(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Set frame transparency and maximize windows by default.
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
;; (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
;; (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; (add-to-list 'default-frame-alist '(fullscreen . fullheight))
(toggle-frame-maximized)

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold most-positive-fixnum)

;; Silence compiler warnings as they can be pretty disruptive
(setq native-comp-async-report-warnings-errors nil)
(setq comp-async-report-warnings-errors nil)
(setq warning-minimum-level :emergency)
(setq large-file-warning-threshold nil)
(setq vc-follow-symlinks t)
(setq ad-redefinition-action 'accept)
(require 'subr-x)
(setq bl/is-termux
      (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))

(setq bl/is-guix-system (and (eq system-type 'gnu/linux)
                             (require 'f)
                             (string-equal (f-read "/etc/issue")
                                           "\nThis is the GNU system.  Welcome.\n")))
;; set font size
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)


;;显示语法高亮
(global-font-lock-mode t)

;;设置编码
(set-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-16-le)
(set-default-coding-systems 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)  
(set-file-name-coding-system 'gb18030)

;;内部有个自动补全功能，根据当前buffer的内容、文件名、剪切板等自动补全
(setq hippie-expand-try-functions-list
      '(
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(require 'package)
;;optimise loading package
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                           ("melpa-stable" . "https://stable.melpa.org/packages/")
                           ("org" . "https://orgmode.org/elpa/")
                           ("elpa" . "https://elpa.gnu.org/packages/")))
;; (setq package-archives '(("gnu"   . "http://1.15.88.122/gnu/")
;;                         ("melpa" . "http://1.15.88.122/melpa/")))
;; set third party of source
;; (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
;;                          ("melpa" . "http://elpa.emacs-china.org/melpa/")))
;; (setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
;;                          ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")))
;; (setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;                          ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))


(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
(package-refresh-contents)
(package-install 'use-package))
(setq use-package-always-ensure t)

;; Settings for exec-path-from-shell
;; fix the PATH environment variable issue
(use-package exec-path-from-shell
  :ensure t
  :when (or (memq window-system '(mac ns x))
	    (unless cabins--os-win
	      (daemonp)))
  :init (exec-path-from-shell-initialize))


(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))
  
(use-package vertico
  ;; Special recipe to load extensions conveniently
  :straight (vertico :files (:defaults "extensions/*")
                     :includes (vertico-indexed
                                vertico-flat
                                vertico-grid
                                vertico-mouse
                                vertico-quick
                                vertico-buffer
                                vertico-repeat
                                vertico-reverse
                                vertico-directory
                                vertico-multiform
                                vertico-unobtrusive
                                ))
  :general
  (:keymaps 'vertico-map
   "<tab>" #'vertico-insert    ; Choose selected candidate
   "<escape>" #'minibuffer-keyboard-quit ; Close minibuffer)
  :custom
  (vertico-count 13)                    ; Number of candidates to display
  (vertico-resize t)
  (vertico-cycle nil) ; Go from last to first candidate and first to last (cycle)?
  :config
  (vertico-mode))
  (vertico-buffer-mode)

(package-install 'orderless)
(setq completion-styles '(orderless))

(use-package marginalia
  :general
  (:keymaps 'minibuffer-local-map
   "M-A" 'marginalia-cycle)
  :custom
  (marginalia-max-relative-age 0)
  (marginalia-align 'right)
  :init
  (marginalia-mode))

(package-install 'embark)
(global-set-key (kbd "C-;") 'embark-act)
(setq prefix-help-command 'embark-prefix-help-command)

(package-install 'consult)
;;replace swiper
(global-set-key (kbd "C-s") 'consult-line)
;;consult-imenu
(global-set-key (kbd "M-s i") 'consult-imenu)

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)


;; 这个快捷键绑定可以用之后的插件 counsel 代替
;; (global-set-key (kbd "C-x C-r") 'recentf-open-files)
;; (global-set-key (kbd "C-x b") 'consult-buffer)


(delete-selection-mode 1)
;; find-function （ C-h C-f ）
(global-set-key (kbd "C-h C-f") 'find-function)
;; find-variable （ C-h C-v ）
(global-set-key (kbd "C-h C-v ") 'find-variable)
;; find-function-on-key （ C-h C-k ）
(global-set-key (kbd "C-h C-k") 'find-function-on-key)


(defun consult-directory-externally (file)
  "Open FILE externally using the default application of the system."
  (interactive "fOpen externally: ")
  (if (and (eq system-type 'windows-nt)
	   (fboundp 'w32-shell-execute))
      (shell-command-to-string (encode-coding-string (replace-regexp-in-string "/" "\\\\"
	    (format "explorer.exe %s" (file-name-directory (expand-file-name file)))) 'gbk))
    (call-process (pcase system-type
		    ('darwin "open")
		    ('cygwin "cygstart")
		    (_ "xdg-open"))
		  nil 0 nil
		  (file-name-directory (expand-file-name file)))))

 (define-key embark-file-map (kbd "E") #'consult-directory-externally)
;;打开当前文件的目录
(defun my-open-current-directory ()
  (interactive)
  (consult-directory-externally default-directory))


(package-install 'embark-consult)
(package-install 'wgrep)
(setq wgrep-auto-save-buffer t)

(eval-after-load
    'consult
  '(eval-after-load
       'embark
     '(progn
	(require 'embark-consult)
	(add-hook
	 'embark-collect-mode-hook
	 #'consult-preview-at-point-mode))))

(defun embark-export-write ()
  "Export the current vertico results to a writable buffer if possible.
Supports exporting consult-grep to wgrep, file to wdeired, and consult-location to occur-edit"
  (interactive)
  (require 'embark)
  (require 'wgrep)
  (pcase-let ((`(,type . ,candidates)
               (run-hook-with-args-until-success 'embark-candidate-collectors)))
    (pcase type
      ('consult-grep (let ((embark-after-export-hook #'wgrep-change-to-wgrep-mode))
                       (embark-export)))
      ('file (let ((embark-after-export-hook #'wdired-change-to-wdired-mode))
               (embark-export)))
      ('consult-location (let ((embark-after-export-hook #'occur-edit-mode))
                           (embark-export)))
      (x (user-error "embark category %S doesn't support writable export" x)))))

(global-set-key minibuffer-local-map (kbd "C-c C-e") 'embark-export-write)

;;使用ripgrep来进行搜索
;;consult-ripgrep

;;everyting
;;consult-locate
;; 配置搜索中文
(progn
  (setq consult-locate-args (encode-coding-string "es.exe -i -p -r" 'gbk))
  (add-to-list 'process-coding-system-alist '("es" gbk . gbk))
  )
(eval-after-load 'consult
  (progn
      (setq
	consult-narrow-key "<"
	consult-line-numbers-widen t
	consult-async-min-input 2
	consult-async-refresh-delay  0.15
	consult-async-input-throttle 0.2
	consult-async-input-debounce 0.1)
    ))



;; 设置平滑滚动
(unless bl/is-termux
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
  (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
  (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
  (setq scroll-step 1) ;; keyboard scroll one line at a time
  (setq use-dialog-box nil)) ;; Disable dialog boxes since they weren't working in Mac OSX



;; ;; 滚动半屏设置
;; (defun window-half-height ()
;;   (max 1 (/ (- (1- (window-height (selected-window))) 4) 2)))
;; (defun scroll-up-half ()
;;   (interactive)
;;   (scroll-up (window-half-height)))
;; (defun scroll-down-half ()
;;   (interactive)
;;   (scroll-down (window-half-height)))
;; (global-set-key (kbd "M-N") 'scroll-up-half)
;; (global-set-key (kbd "M-P") 'scroll-down-half)

;; (use-package good-scroll
;;              :ensure t
;;              :init (good-scroll-mode))


;; chords
(use-package use-package-chords
  :ensure t
  :disabled
  :config (key-chord-mode 1))

;; Diminish
(use-package diminish
  :ensure t)

;; restart emacs
(use-package restart-emacs
  :ensure t)
;;(org-babel-load-file (expand-file-name "~/.emacs.d/my-init.org"))

;; get system type
(defconst *is-mac* (eq system-type 'darwin))
(defconst *is-linux* (eq system-type 'gnu/linux))
(defconst *is-windows* (or (eq system-type 'ms-dos)(eq system-type 'windows-nt)))
(defconst CACHE-DIR (expand-file-name "cache/" user-emacs-directory))

;; (add-to-list 'load-path "~/.emacs.d/etc/lisp")
;; (add-to-list 'load-path "~/.emacs.d/etc/lisp/lsp-bridge")
;; (add-to-list 'load-path "~/.emacs.d/etc/lisp/cape")
;; (add-to-list 'load-path "~/.emacs.d/etc/lisp/emacs-forfu-terminal")
(add-to-list 'load-path "~/.emacs.d/theme")


(load-file (expand-file-name "init-early.el" user-emacs-directory))

;; (use-package mwim
;;   :ensure t
;;   :bind
;;   ("C-a" . mwim-beginning-of-code-or-line)
;;   ("C-e" . mwim-end-of-code-or-line))

;; user custom config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))


;; command key to meta for default
(when *is-mac*
  (setq mac-option-modifier 'meta
      mac-command-modifier 'super))

;; 对应Windows上面的Ctrl-a 全选
(global-set-key (kbd "s-a") 'mark-whole-buffer) 
;; 对应Windows上面的Ctrl-c 复制
(global-set-key (kbd "s-c") 'kill-ring-save) 
;; 对应Windows上面的Ctrl-s 保存
(global-set-key (kbd "s-s") 'save-buffer) 
;; 对应Windows上面的Ctrl-v 粘贴
(global-set-key (kbd "s-v") 'yank) 
;; 对应Windows上面的Ctrol-z 撤销
(global-set-key (kbd "s-z") 'undo) 
;; 对应Windows上面的Ctrol-x 剪切
(global-set-key (kbd "s-x") 'kill-region) 

(setq-default evil-shift-width tab-width)
(setq tab-always-indent 'complete)
;; Use spaces instead of tabs for indentation
(setq-default indent-tabs-mode nil)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode t)

;(global-set-key (kbd "C-x C-b") 'bufler)
;; (global-set-key (kbd "C-x C-b") 'projectile-ibuffer)

;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering)


;; (defun my-default-window-setup ()
;;   "Called by emacs-startup-hook to set up my initial window configuration."
;;   (split-window-right)
;;   (other-window 1)
;;   (find-file "~/Sync/orgFiles/todo.org")
;;   (other-window 1))

;; (add-hook 'emacs-startup-hook #'my-default-window-setup)


;(setq ido-enable-flex-matching t)
;(setq ido-everywhere t)
;(setq ido-use-filename-at-point 'guess)
;(ido-mode 1)




(defun show-in-finder ()
  (interactive)
  (shell-command (concat "open -R " buffer-file-name)))



;; 快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; 这一行代码，将函数 open-init-file 绑定到 <f2> 键上
(global-set-key (kbd "<f2>") 'open-init-file)

(set-face-attribute 'web-mode-css-rule-face nil :foreground "Pink3")

;; Set font size 100 = 100pt
(set-face-attribute 'default nil :height 100)

(set-frame-font "Monaco-14" t t))

