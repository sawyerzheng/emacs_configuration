;; -*- coding: utf-8; -*-
(use-package elfeed
  :straight t
  :commands (elfeed elfeed-update elfeed-update-feed elfeed-dashboard)
  :config
  ;; (setq elfeed-feeds
  ;;       '(("http://nullprogram.com/feed/" blog emacs)
  ;;         ("https://planet.emacslife.com/atom.xml" emacs)
  ;;         ("http://planetpython.org/rss20.xml" python)
  ;;         ("http://planet.scipy.org/rss20.xml" python)))
  (use-package elfeed-org
    :straight t
    :config
    (setq rmh-elfeed-org-files '("~/org/elfeed.org"))
    (elfeed-org))
  (use-package elfeed-goodies
    :straight t
    :config
    (elfeed-goodies/setup))
  ;; (use-package elfeed-dashboard
  ;;   :straight t
  ;;   :config
  ;;   (setq elfeed-dashboard-file "~/.conf.d/elfeed-dashboard.org")
  ;;   (advice-add 'elfeed-search-quit-window :after #'elfeed-dashboard-update-links))
  )

(provide 'init-elfeed)
