;; -*- coding: utf-8; -*-
(use-package elfeed
  :straight t
  :config
  (setq elfeed-feeds
        '(("http://nullprogram.com/feed/" blog emacs))))

(provide 'init-elfeed)
