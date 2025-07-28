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

;; (with-eval-after-load 'ob
;;   (org-babel-load-file (expand-file-name "scimax/scimax-notebook.org" my/extra.d-dir))
;; )

(use-package scimax-notebook
  :config
  (let ((org-confirm-babel-evaluate nil))
    (org-babel-load-file (locate-library "scimax-notebook.org")))
  :commands (
	     nb-example-main
	     nb-new
	     nb-open
	     nb-git-clone
	     nb-clone
	     nb-org-files
	     nb-agenda
	     nb-search-agenda
	     nb-git-archive
	     nb-archive
	     nb-list-tags
	     nb-set-tags
	     nb-update-scimax-projects-menu
	     nb-search
	     nb-search-all
	     nb-search-title
	     nb-help
	     nb-assign-task
	     nb-contacts
	     nb-parse-path
	     nb-follow
	     nb-follow-other
	     nb-follow-other-frame
	     nb-follow-sys
	     nb-store-link
	     nb-complete-link
	     nb-insert-link
	     nb-link-face
	     nb-link-tooltip
	     nb-activate-link
	     nb-link-bash
	     nb-link-explorer
	     nb-link-projectile-find-file
	     nb-event
	     nb-uuid
	     )
  ;; :demand t
  ;; :after org
  )
(add-to-list 'load-path (expand-file-name "scimax/org-show" my/extra.d-dir))

;; (use-package ivy-xref
;;   :commands (ivi))
;;; org slide show 
(use-package org-show
  :commands (org-show-mode
             org-show-help))

;;; org table tools
(use-package scimax-org-table
  :after org
  :commands (scimax-org-table-export/body)
  )

(provide 'init-scimax-notebook)
;;; init-scimax-notebook.el ends here
