;; -*- coding: utf-8; -*-
;; ref: https://github.com/antonj/Highlight-Indentation-for-Emacs
(use-package highlight-indentation
  :straight t
  :hook (prog-mode . highlight-indentation-mode)
  :config)

(provide 'init-highlight-indentation)
