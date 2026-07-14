;; -*- coding: utf-8; -*-
(use-package valign
  ;; notice: valign is very CPU comsuming
  ;; :hook ((org-mode markdown-mode md-ts-mode gfm-mode markdown-ts-mode) . valign-mode)
  :commands (valign-mode)
  :config
  (setq valign-fancy-bar t
        valign-max-table-size 40000)
  )

(provide 'init-valign)
