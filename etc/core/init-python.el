(use-package python
  :mode ("\\.py" . python-mode)
  :ensure t)

(use-package pyvenv)

(use-package python-black
  :demand t
  :after python
  :config
  (python-black-on-save-mode))

(use-package pyenv-mode
  :init
  (add-to-list 'exec-path "~/.pyenv/shims")
  (setenv "WORKON_HOME" "~/.pyenv/versions/")
  :config
  (pyenv-mode))