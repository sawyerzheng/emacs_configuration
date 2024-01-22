;; -*- coding: utf-8; -*-
(use-package nov
  :straight t
  :mode (("\\.epub\\'" . nov-mode))
  :config
  (setq nov-text-width 100)
  ;; (require 'nov)
  ;; (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  )

(provide 'init-nov)
