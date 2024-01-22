(use-package pdf-tools
  :defer t
  :commands (pdf-view-mode pdf-tools-install)
  :mode("\\.[pP][dD][fF]\\'" . pdf-view-mode)
  :magic("%PDF" . pdf-view-mode)
  :config
    (pdf-tools-install)  ; Standard activation command
    (pdf-loader-install) ; On demand loading, leads to faster startup time
    (define-pdf-cache-function pagelabels)
  :hook ((pdf-view-mode-hook . (lambda()(display-line-numbers-mode -1)))
        (pdf-view-mode-hook . pdf-tools-enable-minor-nodes))
  :bind ((:map pdf-view-mode-map ("C--" . pdf-view-shrink))
         (:map pdf-view-mode-map ("C-=" . pdf-view-enlarge))
         (:map pdf-view-mode-map ("C-0" . pdf-view-scale-reset))))



(provide 'init-pdf-tools)