;; -*- coding: utf-8; -*-
(use-package valign
  :straight t
  :hook ((org-mode markdown-mode) . valign-mode)
  :config
  (setq valign-fancy-bar t
        valign-max-table-size 40000)
  )

(provide 'init-valign)
