;; -*- coding: utf-8; -*-
(use-package which-key
  :straight t 
  :delight
  (which-key-mode)
  :commands which-key-mode
  :hook (my/startup . which-key-mode))

(provide 'init-which-key)
