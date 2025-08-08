;;; init-eldoc-helper.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: August 08, 2025
;; Modified: August 08, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-eldoc-helper
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(defvar rb--eldoc-html-patterns
  '(("&nbsp;" " ")
    ("&lt;" "<")
    ("&gt;" ">")
    ("&amp;" "&")
    ("&quot;" "\"")
    ("&apos;" "'"))
  "List of (PATTERN . REPLACEMENT) to replace in eldoc output.")

(defun rb--string-replace-all (patterns in-string)
  "Replace all cars from PATTERNS in IN-STRING with their pair."
  (mapc (lambda (pattern-pair)
          (setq in-string
                (string-replace (car pattern-pair) (cadr pattern-pair) in-string)))
        patterns)
  in-string)

(defun rb--eldoc-preprocess (orig-fun &rest args)
  "Preprocess the docs to be displayed by eldoc to replace HTML escapes."
  (let ((doc (car args)))
    ;; The first argument is a list of (STRING :KEY VALUE ...) entries
    ;; we replace the text in each such string
    ;; see docstring of `eldoc-display-functions'
    (when (listp doc)
      (setq doc (mapcar
                 (lambda (doc) (cons
                                (rb--string-replace-all rb--eldoc-html-patterns (car doc))
                                (cdr doc)))
                 doc
                 ))
      )
    (apply orig-fun (cons doc (cdr args)))))

(with-eval-after-load 'eldoc
  (with-eval-after-load 'eglot
    (advice-add 'eldoc-display-in-buffer :around #'rb--eldoc-preprocess)
    ))

(provide 'init-eldoc-helper)
;;; init-eldoc-helper.el ends here
