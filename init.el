;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

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

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

; (add-hook 'emacs-startup-hook
;           (lambda ()
;             "Recover GC values after startup."
;             (setq gc-cons-threshold 800000
;                   gc-cons-percentage 0.1)))
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))


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
(setq-default cursor-type 'box)


(electric-pair-mode t)                       ; 自动补全括号
(add-hook 'prog-mode-hook #'show-paren-mode) ; 编程模式下，光标在括号上时高亮另一个括号
(column-number-mode t)                       ; 在 Mode line 上显示列号
(delete-selection-mode t)                    ; 选中文本后输入文本会替换文本（更符合我们习惯了的其它编辑器的逻辑）
(add-hook 'prog-mode-hook #'hs-minor-mode)   ; 编程模式下，可以折叠代码块
(when (display-graphic-p) (toggle-scroll-bar -1)) ; 图形界面时关闭滚动条
(global-set-key (kbd "C-c '") 'comment-or-uncomment-region) ; 为选中的代码加注释/去注释


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

;; disable cl warning
(setq byte-compile-warnings '(cl-functions))

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

(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Set frame transparency and maximize windows by default.
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . fullheight))

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

;; Set font size 180 = 18pt
(set-face-attribute 'default nil :height 140)

(require 'package)
;;optimise loading package
  ;; (setq package-archives '(("melpa" . "https://melpa.org/packages/")
  ;;                          ("melpa-stable" . "https://stable.melpa.org/packages/")
  ;;                          ("org" . "https://orgmode.org/elpa/")
  ;;                          ("elpa" . "https://elpa.gnu.org/packages/")))
(setq package-archives '(("gnu"   . "http://1.15.88.122/gnu/")
                        ("melpa" . "http://1.15.88.122/melpa/")))
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



;; 设置平滑滚动
(unless bl/is-termux
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
  (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
  (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
  (setq scroll-step 1) ;; keyboard scroll one line at a time
  (setq use-dialog-box nil)) ;; Disable dialog boxes since they weren't working in Mac OSX



;; 保持鼠标所在行数不变屏幕向下滚动一行
(global-set-key (kbd "M-n") 'scroll-up-line)

;; 保持鼠标所在行数不变屏幕向上滚动一行
(global-set-key (kbd "M-p") 'scroll-down-line)


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

(add-to-list 'load-path "~/.emacs.d/etc/lisp")
(add-to-list 'load-path "~/.emacs.d/etc/lisp/lsp-bridge")
(add-to-list 'load-path "~/.emacs.d/etc/lisp/cape")
(add-to-list 'load-path "~/.emacs.d/etc/lisp/emacs-forfu-terminal")
(add-to-list 'load-path "~/.emacs.d/etc/core")
(add-to-list 'load-path "~/.emacs.d/theme")


(load-file (expand-file-name "init-early.el" user-emacs-directory))

(use-package mwim
  :ensure t
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

;; user custom config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))


;; command key to meta for default
(when *is-mac*
   (setq mac-command-modifier 'meta
    mac-option-modifier 'none))

;; Tab Widths
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)
;; Use spaces instead of tabs for indentation
(setq-default indent-tabs-mode nil)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode t)

;(global-set-key (kbd "C-x C-b") 'bufler)
(global-set-key (kbd "C-x C-b") 'projectile-ibuffer)

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