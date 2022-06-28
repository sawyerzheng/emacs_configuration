;; -*- coding: utf-8; -*-
;; ref: https://github.com/antonj/Highlight-Indentation-for-Emacs
(use-package highlight-indentation
  :defer t
  :hook (prog-mode . highlight-indentation-mode))

(provide 'init-highlight-indentation)
