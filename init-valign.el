;; -*- coding: utf-8; -*-
(use-package valign
  :straight t
  :hook ((org-mode markdown-mode) . valign-mode))

(provide 'init-valign)
