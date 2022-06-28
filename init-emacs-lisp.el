(use-package elisp-def
  :straight t
  :hook ((emacs-lisp-mode ielm-mode) . elisp-def-mode)
  :config
  (use-package highlight-quoted
    :straight t
    :hook ((emacs-lisp-mode ielm-mode) . highlight-quoted-mode))

  (use-package highlight-defined
    :straight t
    :hook ((emacs-lisp-mode ielm-mode) . highlight-quoted-mode))

  (use-package elisp-demos
    :straight t
    :commands (elisp-demos-advice-describe-function-1))

  ;; for `elisp-demos' in help-mode
  ;; (use-package help-mode
  ;;   :straight (:type built-in)
  ;;   :commands help-mode
  ;;   :config
  ;;   (require 'elisp-demos)
  ;;   (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1))
  (require 'init-lispy)
  (require 'init-helpful))

  (provide 'init-emacs-lisp)
