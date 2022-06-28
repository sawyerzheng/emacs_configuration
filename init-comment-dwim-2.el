(use-package comment-dwim-2
  :straight t
  :bind ( ("M-;" . comment-dwim-2)
          :map org-mode-map
          ("M-;" . org-comment-dwim-2)))

(provide 'init-comment-dwim-2)
