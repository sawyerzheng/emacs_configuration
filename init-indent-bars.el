;; -*- coding: utf-8; -*-
(use-package indent-bars
  ;; :hook ((python-mode yaml-mode) . indent-bars-mode)
  :hook (prog-mode . indent-bars-mode)
  :bind ("C-c u i" . indent-bars-mode)
  :config
  (require 'indent-bars-ts) 		; not needed with straight
  (setq indent-bars-width-frac 0.1)
  ;; (setq
  ;;  indent-bars-color '(highlight :face-bg t :blend 0.2)
  ;;  indent-bars-pattern "."
  ;;  indent-bars-width-frac 0.1
  ;;  indent-bars-pad-frac 0.1
  ;;  indent-bars-zigzag nil
  ;;  indent-bars-color-by-depth nil
  ;;  indent-bars-highlight-current-depth nil
  ;;  indent-bars-display-on-blank-lines nil)

  (setq
   indent-bars-color '(highlight :face-bg t :blend 0.15)
   indent-bars-pattern "."
   indent-bars-width-frac 0.13
   indent-bars-pad-frac 0.1
   indent-bars-zigzag nil
   indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1) ; blend=1: blend with BG only
   indent-bars-highlight-current-depth '(:blend 0.5) ; pump up the BG blend on current
   indent-bars-display-on-blank-lines t)
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
