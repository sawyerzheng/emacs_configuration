(use-package display-line-numbers
  :hook ((prog-mode markdown-mode gfm-mode fish-mode conf-mode) . display-line-numbers-mode)
  :config
  (setq display-line-numbers-width 2))

(provide 'init-line-number)
