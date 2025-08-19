;;; init-minuet.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: August 18, 2025
;; Modified: August 18, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-minuet
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package minuet
  :commands (minuet-auto-suggestion-mode
             minuet-show-suggestion
             minuet-complete-with-minibuffer
             minuet-configure-provider)
  :bind (:map minuet-active-mode-map
              ;; These keymaps activate only when a minuet suggestion is displayed in the current buffer
              ("M-p" . #'minuet-previous-suggestion) ;; invoke completion or cycle to next completion
              ("M-n" . #'minuet-next-suggestion) ;; invoke completion or cycle to previous completion
              ("M-A" . #'minuet-accept-suggestion) ;; accept whole completion
              ;; Accept the first line of completion, or N lines with a numeric-prefix:
              ;; e.g. C-u 2 M-a will accepts 2 lines of completion.
              ("M-a" . #'minuet-accept-suggestion-line)
              ("M-e" . #'minuet-dismiss-suggestion))
  :config
  ;; You can use M-x minuet-configure-provider to interactively configure provider and model
  ;; (setq minuet-provider 'openai-fim-compatible)

  (minuet-set-optional-options minuet-openai-fim-compatible-options :max_tokens 64))

(provide 'init-minuet)
;;; init-minuet.el ends here
