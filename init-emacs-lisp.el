(use-package elisp-mode
  :commands (emacs-lisp-mode)
  :config
  (font-lock-add-keywords 'emacs-lisp-mode '(("\\_<[+-]1\\_>" . 'font-lock-keyword-face)
                                             )))
(use-package elisp-def
  :straight t
  :hook ((emacs-lisp-mode ielm-mode lisp-interaction-mode) . elisp-def-mode)
  :config
  (use-package highlight-quoted
    :straight t
    :hook ((emacs-lisp-mode ielm-mode lisp-interaction-mode) . highlight-quoted-mode))

  (use-package highlight-defined
    :straight t
    :hook ((emacs-lisp-mode ielm-mode lisp-interaction-mode) . highlight-quoted-mode))

  (require 'init-lispy)
  (require 'init-helpful))

(use-package rainbow-delimiters
  :straight t
  :hook ((emacs-lisp-mode
          ielm-mode
          lisp-interaction-mode
          python-mode) . rainbow-delimiters-mode))

(defalias 'elisp-mode #'emacs-lisp-mode)

(provide 'init-emacs-lisp)
