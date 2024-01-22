

(use-package all-the-icons
  :straight (all-the-icons :type git :host github :repo "domtronn/all-the-icons.el" :branch "svg" :files (:defaults "svg"))
  :if (display-graphic-p))


(setq image-cache-eviction-delay nil) ;; or set it to a much longer time than 5 minutes


(provide 'init-icons)