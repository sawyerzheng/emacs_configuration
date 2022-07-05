(provide 'init-auto-save)

(use-package real-auto-save
  :straight t
  :hook ((prog-mode markdown-mode org-mode) . real-auto-save-mode)
  :config
  (setq real-auto-save-interval 5))
