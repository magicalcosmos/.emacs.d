;; common emacs 

  ;; get system type
(defconst *is-mac* (eq system-type 'darwin))
(defconst *is-linux* (eq system-type 'gnu/linux))
(defconst *is-windows* (or (eq system-type 'ms-dos)(eq system-type 'windows-nt)))
(defconst CACHE-DIR (expand-file-name "cache/" user-emacs-directory))

;; command key to meta for default
(when *is-mac*
  (setq mac-command-modifier 'meta))

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


(provide 'init-common)