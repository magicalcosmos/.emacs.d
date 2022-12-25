(use-package fzf
  :bind
    ;; Don't forget to set keybinds!
  :config
  (setq fzf/args "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"
        ;; command used for `fzf-grep-*` functions
        ;; example usage for ripgrep:
        ;; fzf/grep-command "rg --column --line-number --no-heading --color=always --smart-case"
        fzf/fd "--type f --strip-cwd-prefix --hidden --follow --exclude .git"
        fzf/grep-command "grep -nrH"
        ;; If nil, the fzf buffer will appear at the top of the window
        fzf/position-bottom t
        fzf/window-height 15))


(provide 'init-fzf)