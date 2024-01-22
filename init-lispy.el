(use-package lispy
  :straight (lispy :files (:defaults "*"))
  ;; :init
  ;; (my/add-extra-folder-to-load-path "lispy" (list "targets" "lispytutor"))
  :hook ((emacs-lisp-mode . lispy-mode)
         ;; (minibuffer-setup . conditionally-enable-lispy)
         )
  :bind (:map lispy-mode-map
              ("M-o" . nil)
              ("M-j" . nil)
              ("M-i" . nil))
  :config
  (defun conditionally-enable-lispy ()
    (when (eq this-command 'eval-expression)
      (lispy-mode 1))))

(provide 'init-lispy)
