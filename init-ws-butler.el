(use-package ws-butler
  :straight t
  :hook ((prog-mode org-mode markdown-mode gfm-mode) . ws-butler-mode))

(provide 'init-ws-butler)
