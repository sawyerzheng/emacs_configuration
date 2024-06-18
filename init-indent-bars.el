;; -*- coding: utf-8; -*-
(use-package indent-bars
  :straight (indent-bars :type git :host github :repo "jdtsmith/indent-bars")
  :hook ((python-mode yaml-mode) . indent-bars-mode)

  :config
  (require 'indent-bars-ts) 		; not needed with straight
  (setq indent-bars-width-frac 0.2)
  :custom
  (indent-bars-treesit-support t)
  (indent-bars-treesit-ignore-blank-lines-types '("module"))
  ;; Add other languages as needed
  (indent-bars-treesit-scope '((python function_definition class_definition for_statement
	                               if_statement with_statement while_statement)))
  ;; wrap may not be needed if no-descend-list is enough
  ;;(indent-bars-treesit-wrap '((python argument_list parameters ; for python, as an example
  ;;				      list list_comprehension
  ;;				      dictionary dictionary_comprehension
  ;;				      parenthesized_expression subscript)))
  :hook ((python-base-mode yaml-mode) . indent-bars-mode)
  :hook (prog-mode . indent-bars-mode)
  )


(provide 'init-indent-bars)
