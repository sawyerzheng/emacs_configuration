;;; init-ox-pandoc.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: August 01, 2025
;; Modified: August 01, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-ox-pandoc
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
(use-package ox-pandoc
  :after ox
  :init
  (add-to-list 'org-export-backends 'pandoc)
  :config
  (add-to-list  'org-pandoc-valid-options 'embed-resources))

(provide 'init-ox-pandoc)
;;; init-ox-pandoc.el ends here
