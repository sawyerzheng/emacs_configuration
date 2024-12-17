;; load snippet tables  -*- coding: utf-8; -*-

(my/straight-if-use 'yasnippet)
(my/straight-if-use 'yasnippet-snippets)
(use-package yasnippet
  :init
  (defun my/enable-yas-local-fn ()
    (unless (fboundp #'yas-reload-all)
      (require 'yasnippet))
    (yas-reload-all)
    (yas-minor-mode 1))
  :commands (my/enable-yas-local-fn)
  ;; :hook (((prog-mode org-mode) . my/enable-yas-local-fn))
  :config
  (require 'yasnippet-snippets)
  (add-to-list 'yas-snippet-dirs "~/.conf.d/custom.d/snippets")
  ;; (yas-reload-all)
  )

(my/straight-if-use 'auto-yasnippet)
(use-package auto-yasnippet
  :commands (aya-create
             aya-expand
             aya-expand-from-history
             aya-delete-from-history
             aya-clear-history
             aya-next-in-history
             aya-previous-in-history
             aya-persist-snippet)

  )


(provide 'init-yasnippet)
