;; -*- coding: utf-8; -*-
(use-package valign
  :hook ((org-mode markdown-mode md-ts-mode gfm-mode markdown-ts-mode) . valign-mode)
  :config
  (setq valign-fancy-bar t
        valign-max-table-size 40000)
  )

(provide 'init-valign)
