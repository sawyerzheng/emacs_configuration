;;; init-outorg.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 sawyer
;;
;; Author: sawyer <sawyer@helium>
;; Maintainer: sawyer <sawyer@helium>
;; Created: January 21, 2026
;; Modified: January 21, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-outorg
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package outorg
  :init
  (defun my/outorg--edit-save-as-one-command ()
    (interactive)
    (cond ((string= (buffer-name) outorg-edit-buffer-name)
           (call-interactively #'outorg-copy-edits-and-exit))
          (t
           (call-interactively #'outorg-edit-as-org))))
  ;; :bind ("C-c '" . outorg-edit-as-org)
  :bind (:map outorg-edit-minor-mode
              ;; ("C-c '" . outorg-copy-edits-and-exit)
              ("C-c '" . my/outorg--edit-save-as-one-command)
              )
  )

(provide 'init-outorg)
;;; init-outorg.el ends here
