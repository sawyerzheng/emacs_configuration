;; -*- coding: utf-8; -*-
(my/straight-if-use 'page-break-lines)
(use-package page-break-lines
  :hook ((
	  lisp-mode
	  scheme-mode
	  compilation-mode
	  outline-mode 
	  emacs-lisp-mode
          help-mode
          helpful-mode) . page-break-lines-mode))

(provide 'init-page-break-lines)
