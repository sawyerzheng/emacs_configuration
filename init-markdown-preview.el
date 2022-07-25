(use-package markdown-preview-mode
  :straight t
  :commands (markdown-preview-mode)
  :after markdown-mode
  :bind (:map markdown-mode-command-map
              ("P" . markdown-preview-mode))
  :config
  (if my/windows-p
      (setq markdown-preview-delay-time 1)
    (setq markdown-preview-delay-time 0.5))

  ;; (add-to-list 'markdown-preview-stylesheets "https://raw.githubusercontent.com/richleland/pygments-css/master/emacs.css")
  ;; (add-to-list 'markdown-preview-stylesheets "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.1.0/github-markdown-light.css")
  (add-to-list 'markdown-preview-stylesheets "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.1.0/github-markdown-dark.css")

  ;; (setq markdown-preview-stylesheets '("https://thomasf.github.io/solarized-css/solarized-dark.min.css"))
  ;; (setq markdown-preview-stylesheets '("https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.1.0/github-markdown-light.css"))
  ;; (setq markdown-preview-stylesheets '("https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.1.0/github-markdown-dark.css"))
  ;; (add-to-list 'markdown-preview-javascript '("http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML" . async))
  (setq markdown-preview-javascript '("http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML"))
  (setq markdown-preview-http-port 19080))


(provide 'init-markdown-preview)
