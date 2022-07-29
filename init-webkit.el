(provide 'init-webkit)

(use-package webkit
  :after org
  :straight (webkit :type git :host github :repo "akirakyle/emacs-webkit"
                    :branch "main"
                    :files (:defaults "*.js" "*.css" "*.so")
                    :pre-build ("make"))
  :config
  (use-package webkit-ace) ;; If you want link hinting
  (use-package webkit-dark) ;; If you want to use the simple dark mode
  )
