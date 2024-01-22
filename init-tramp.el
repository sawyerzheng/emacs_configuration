(use-package docker-tramp
  :straight t
  :after tramp
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(provide 'init-tramp)
