(use-package mathjax
  :straight (:type git :host github :repo "astoff/mathjax.el" :files ("*"))
  :hook (eww-mode . mathjax-shr-setup)
  )


(provide 'init-straight-recipes)
