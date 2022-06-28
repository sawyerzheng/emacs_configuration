(use-package inoreader
  :straight (inoreader :type git :host github :repo "xuchunyang/inoreader.el")
  :commands inoreader-list-unread
  :config
  (setq inoreader-app-id "1000004876"
        inoreader-app-secret "OhBfiFdh63_NtnkbF0k0gJhEKDifJkJB"
        inoreader-redirect-uri "http://localhost:18980"))

(provide 'init-inoreader)
