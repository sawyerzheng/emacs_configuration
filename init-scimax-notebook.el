;;; init-scimax-notebook.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: July 22, 2025
;; Modified: July 22, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-scimax-notebook
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(org-babel-load-file (expand-file-name "scimax-notebook.org" my/extra.d-dir))

(add-to-list 'load-path (expand-file-name "scimax/org-show" my/extra.d-dir))

;; (use-package ivy-xref
;;   :commands (ivi))
;;; org slide show 
(use-package org-show
  :commands (org-show-mode
             org-show-help))

;;; org table tools
(use-package scimax-org-table
  :demand t
  :after org
  :commands (scimax-org-table-export))

(provide 'init-scimax-notebook)
;;; init-scimax-notebook.el ends here
