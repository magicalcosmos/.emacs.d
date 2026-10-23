;;; init-basic.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur: can be helpful to diagnose startup issues
;;(setq debug-on-error t)

;; Author: brodyliao

;; get system type
(defconst *is-mac* (eq system-type 'darwin))
(defconst *is-linux* (eq system-type 'gnu/linux))
(defconst *is-windows* (or (eq system-type 'ms-dos)(eq system-type 'windows-nt)))
(defconst CACHE-DIR (expand-file-name "cache/" user-emacs-directory))
;; 确保缓存目录存在（undo-tree、treemacs 等会写入）
(make-directory CACHE-DIR t)

;; 启动期关 GC 以加快加载，emacs-startup-hook 里恢复。
;; 注意 batch 模式下 startup-hook 不会执行，阈值会一直停在 most-positive-fixnum，
;; 运行期 GC 全废、补全产生的垃圾无法回收，Emacs 用久了会明显变慢。
;; 因此这里直接给出运行期阈值，不依赖 hook。
(defconst my/gc-cons-threshold (* 64 1024 1024))
(defconst my/gc-cons-percentage 0.1)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage my/gc-cons-percentage)

(add-hook 'emacs-startup-hook
          (lambda ()
            "Recover GC values after startup."
            (setq gc-cons-threshold my/gc-cons-threshold
                  gc-cons-percentage my/gc-cons-percentage)))
; gain the emacs default is too low 4k considering that the some of the language server responses are in 800k - 3M range                 
(setq read-process-output-max (* 1024 1024)) ;; 1mb


;; Set frame transparency and maximize windows by default.
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))

;; 最大化, 非沉浸模式
;; (toggle-frame-maximized)

;; 最大化, 浸模式
(toggle-frame-fullscreen)

;; Speed up startup
(setq auto-mode-case-fold nil)

;; 关闭启动画面
(setq inhibit-startup-message t)

;; yes to y, no to n
(fset 'yes-or-no-p 'y-or-n-p)

;; 设置自动加载已修改文件
(global-auto-revert-mode t)

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; 设置 Emacs 的缺省工作路径
(setq default-directory "~/")
;; Windows 下 ~/ 展开为 C:/Users/<用户名>/，EPG/GnuPG 等也依赖 HOME；
;; Emacs GUI 启动时 HOME 可能未设置，显式指定避免路径歧义
(when *is-windows*
  (unless (getenv "HOME")
    (setenv "HOME" (getenv "USERPROFILE"))))

;; Git 的全局配置位置
;;
;; Emacs 在 Windows 上把 HOME 设成 %APPDATA%（因为 user-emacs-directory
;; 是 ~/.emacs.d/，Emacs 据此反推 ~）。而 git 在 Windows 上同样优先用
;; HOME 去找全局 .gitconfig，于是它找的是 %APPDATA%\.gitconfig —— 那里
;; 没有文件，git 便拿不到 user.email/user.name，提交时报：
;;   unable to auto-detect email address (got 'Administrator@...(none)')
;;
;; 真正的全局配置在 %USERPROFILE%\.gitconfig。不要改 HOME（那会破坏
;; user-emacs-directory 的定位），改用 GIT_CONFIG_GLOBAL 明确告诉 git
;; 去哪找——该变量优先级高于 HOME 推导，Emacs 启动的每个 git 子进程
;; （magit、git-gutter、LSP、终端里的 git）都会继承。
(when *is-windows*
  (let ((global-gitconfig (expand-file-name ".gitconfig" (getenv "USERPROFILE"))))
    (when (file-exists-p global-gitconfig)
      (setenv "GIT_CONFIG_GLOBAL" global-gitconfig))))

;; Disable visible scrollbar
(scroll-bar-mode -1)

;; Disable the toolbar
(tool-bar-mode -1)

;; 隐藏菜单栏。启动时已进入全屏（见上方 toggle-frame-fullscreen），
;; 菜单栏只会占用顶部空间且在全屏下无用武之地。
;; 需要临时呼出时用 M-` 或 (menu-bar-mode 1)。
(menu-bar-mode -1)

;; activate line numbering in all buffers/modes
(global-display-line-numbers-mode 1)

;; set type of line numbering (global variable)
(setq display-line-numbers-type 'relative)

;; Activate line numbering in programming modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; 不自动保存 
(setq auto-save-default nil)

;; 不生成备份文件
(setq make-backup-files nil)

;; 不生成 lock 文件
(setq create-lockfiles nil)

(setq-default tab-width 2)

;; Use spaces instead of tabs for indentation
(setq-default indent-tabs-mode nil)

;; user custom config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load-file custom-file))


;; set font size
(set-default-coding-systems 'utf-8)

(prefer-coding-system 'utf-8)

(set-terminal-coding-system 'utf-8)

(set-keyboard-coding-system 'utf-8)

(setq default-buffer-file-coding-system 'utf-8)

;; 字体大小 160 = 16pt；Windows 下西文/中文分别指定字体
(if *is-windows*
    (progn
      ;; 缓解中文字体渲染导致的卡顿
      (setq inhibit-compacting-font-caches t)
      (set-face-attribute 'default nil :family "Consolas" :height 160)
      (dolist (charset '(han cjk-misc bopomofo kana hangul))
        (set-fontset-font t charset (font-spec :family "Microsoft YaHei" :height 160))))
  (set-face-attribute 'default nil :height 160))


(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)

;; 编程模式下，可以折叠代码块                    
(add-hook 'prog-mode-hook #'hs-minor-mode)  

;; ESC Cancels All
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
  
;; 在 Mode line 上显示列号
(column-number-mode t)


;; 错误时的“哔哔”的警告提示音
(setq ring-bell-function 'ignore)

;; 缓解在快速移动时大量代码的语法高亮
(setq redisplay-skip-fontification-on-input t)

;; command key to meta for default
(when *is-mac*
  (setq mac-option-modifier 'super
      mac-command-modifier 'meta ))


(provide 'init-basic)