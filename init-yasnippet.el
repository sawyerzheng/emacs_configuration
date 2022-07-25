;; load snippet tables  -*- coding: utf-8; -*-

(use-package yasnippet
  :straight t
  :hook (((prog-mode org-mode python-mode java-mode emacs-lisp-mode) . yas-minor-mode)
         ;; (after-init-hook . yas-global-mode)
         )
  :config
  (use-package yasnippet-snippets
    :straight t)
  (require 'yasnippet-snippets)
  (add-to-list 'yas-snippet-dirs "~/.conf.d/custom.d/snippets")
  (yas-reload-all))

(provide 'init-yasnippet)
