;;; init-ox-ipynb.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: July 23, 2025
;; Modified: July 23, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-ox-ipynb
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package ox-ipynb
  :after ox
  :init
  (add-to-list 'org-export-backends 'ipynb)
  (setq org-pandoc-options
        '((standalone . t)
          (mathjax . t)
          (variable . "revealjs-url=https://revealjs.com"))))

(provide 'init-ox-ipynb)
;;; init-ox-ipynb.el ends here
