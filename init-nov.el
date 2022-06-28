;; -*- coding: utf-8; -*-
(use-package nov
  :ensure t
  :config
  (require 'nov)
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(provide 'init-nov)
