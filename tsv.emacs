;; -*- coding: utf-8-unix; -*-
;; https://www.emacswiki.org/emacs/TsvMode

;; ** Navigate:
;; TAB             tsv-next-field
;; <backtab>       tsv-prev-field
;; C-v             tsv-scroll-up
;; M-v             tsv-scroll-down
;; j               next-line
;; k               previous-line

;; (use-package tsv
;;   :ensure t)
(autoload 'tsv-mode "tsv-mode" "A mode to edit table like file" t)
(autoload 'tsv-normal-mode "tsv-mode" "A minor mode to edit table like file" t)
