;;; init-breadcrumb.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: August 05, 2025
;; Modified: August 05, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-breadcrumb
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
(use-package breadcrumb
  :commands (breadcrumb-mode breadcrumb-local-mode)
  :config
  (setq breadcrumb-imenu-max-length 100)
  :hook (breadcrumb-local-mode . (lambda ()
                                   (setq header-line-format '(:eval (breadcrumb-imenu-crumbs)))))
  :hook ((rust-mode
          rust-ts-mode
          python-mode
          python-ts-mode
          c-mode
          c-ts-mode
          c++-mode
          c++-ts-mode
          emacs-lisp-mode
          emacs-lisp-ts-mode
          java-mode
          java-ts-mode) . breadcrumb-local-mode))


(provide 'init-breadcrumb)
;;; init-breadcrumb.el ends here
