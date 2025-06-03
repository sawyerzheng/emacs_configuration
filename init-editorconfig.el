(use-package editorconfig
  :hook (my/startup . editorconfig-mode)
  :config
  (setq editorconfig-trim-whitespaces-mode #'ws-butler-mode))

(provide 'init-editorconfig)
