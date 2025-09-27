(my/straight-if-use 'grip-mode)
(use-package grip-mode
  :commands (grip-mode)
  :after markdown-mode
  :bind (:map markdown-mode-command-map
              ("g" . grip-mode))
  :config
  (setq grip-command 'go-grip)
  (setq grip-preview-use-webkit nil)
  (setq grip-github-user "sawyerzheng")
  (setq grip-github-password "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")
  (load-file "~/org/private/grip-setup.el")
  ;; * to support dark theme
  ;; uv tool install git+https://github.com/joeyespo/grip
  (setq my/grip-theme "dark") ;; light or dark
  )

(provide 'init-grip)
