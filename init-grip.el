(use-package grip-mode
  :straight t  
  :commands (grip-mode)
  :after markdown-mode
  :bind (:map markdown-mode-command-map
              ("g" . grip-mode))
  :config
  (setq grip-preview-use-webkit nil)
  (setq grip-github-user "sawyerzheng")
  (setq grip-github-password "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"))

(provide 'init-grip)
