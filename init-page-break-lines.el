;; -*- coding: utf-8; -*-
(use-package page-break-lines
  :straight t
  :hook ((emacs-lisp-mode . page-break-lines-mode)
         (helpful-mode . page-break-lines-mode)))

(provide 'init-page-break-lines)
