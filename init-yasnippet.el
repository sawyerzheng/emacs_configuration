;; load snippet tables  -*- coding: utf-8; -*-

(my/straight-if-use 'yasnippet)
(use-package yasnippet
  ;; :straight t
  :hook (((prog-mode org-mode python-mode java-mode emacs-lisp-mode) . yas-minor-mode)
         ;; (my/startup-hook . yas-global-mode)
         )
  :config
  (my/straight-if-use 'yasnippet-snippets)
  ;; (use-package yasnippet-snippets
  ;;   :straight (:type git :host github :repo "AndreaCrotti/yasnippet-snippets" :files ("*")))
  (require 'yasnippet-snippets)
  (add-to-list 'yas-snippet-dirs "~/.conf.d/custom.d/snippets")
  (yas-reload-all))

(my/straight-if-use 'auto-yasnippet)
(use-package auto-yasnippet
  ;; :straight t
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
