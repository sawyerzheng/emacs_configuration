;; -*- coding: utf-8; -*-
;; :ref https://github.com/DarthFennec/highlight-indent-guides
(use-package highlight-indent-guides
  :defer t
  :hook (prog-mode . highlight-indent-guides-mode)
  ;; :custom
  :config
  (setq highlight-indent-guides-method 'column))

(provide 'init-highlight-indent-guides)
