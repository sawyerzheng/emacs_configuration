;; -*- coding: utf-8; -*-
(use-package unicode-fonts
  :straight t
  :hook (after-init . (lambda () (ignore-errors (unicode-fonts-setup)))))

(provide 'init-unicode-fonts)
