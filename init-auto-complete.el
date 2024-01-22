(use-package auto-complete
  :straight t
  :commands (auto-complete
             auto-complete-mode)
  :hook ((sql-mode sql-interactive-mode) . auto-complete-mode)
  :bind (:map ac-mode-map
              ("C-M-i" . auto-complete)
              ("M-i" . nil)
              ))

(provide 'init-auto-complete)
