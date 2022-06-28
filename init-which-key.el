;; -*- coding: utf-8; -*-
(use-package which-key
  :straight t 
  :delight
  (which-key-mode)
  :commands which-key-mode
  :hook (after-init . which-key-mode))

(provide 'init-which-key)
