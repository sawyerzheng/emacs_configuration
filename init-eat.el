;;; init-eat.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 sawyer
;;
;; Author: sawyer <sawyer@helium>
;; Maintainer: sawyer <sawyer@helium>
;; Created: November 11, 2025
;; Modified: November 11, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-eat
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:


(use-package eat
  :commands (eat eat-other-window)
  :config
  ;; * hack for doom theme
  ;; ** doom-vibrant
  ;; change base0 first element to #555f70
  (with-eval-after-load 'ace-window
    (define-key eat-semi-char-mode-map (kbd "M-o") #'ace-window)
    (define-key eat-semi-char-mode-map (kbd "M-O") #'ace-swap-window)
    )
  )

(provide 'init-eat)
;;; init-eat.el ends here
