(provide 'init-auto-sudoedit)

(use-package auto-sudoedit
  :if (not my/windows-p)
  :straight t
  :commands (auto-sudoedit-mode))
