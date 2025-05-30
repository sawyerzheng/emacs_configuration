(use-package elisp-mode
  :commands (emacs-lisp-mode)
  :config
  (font-lock-add-keywords 'emacs-lisp-mode '(("\\_<[+-]1\\_>" . 'font-lock-keyword-face)
                                             )))

(my/straight-if-use 'elisp-def)
(my/straight-if-use 'highlight-defined)
(my/straight-if-use 'highlight-quoted)
(use-package elisp-def
  :hook ((emacs-lisp-mode ielm-mode lisp-interaction-mode) . elisp-def-mode)
  :config
  (use-package highlight-quoted
    :hook ((emacs-lisp-mode ielm-mode lisp-interaction-mode) . highlight-quoted-mode))

  (use-package highlight-defined
    :hook ((emacs-lisp-mode ielm-mode lisp-interaction-mode) . highlight-quoted-mode))

  ;; (require 'init-lispy)
  (require 'init-helpful))

(my/straight-if-use 'rainbow-delimiters)
(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode
          ielm-mode
          lisp-interaction-mode
          python-base-mode) . rainbow-delimiters-mode))

(defalias 'elisp-mode #'emacs-lisp-mode)

;; (use-package elisp-autofmt
;;   :straight (:source (melpa gpu-elpa-mirror))
;;   :hook (emacs-lisp-mode . elisp-autofmt-mode)
;;   )

(provide 'init-emacs-lisp)
