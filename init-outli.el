;;; init-outli.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: July 18, 2025
;; Modified: July 18, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-outli
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:


(use-package outli
  ;; :after (org)
  :commands (outli-mode)
  :hook ((python-base-mode
          java-mode
          java-ts-mode
          rust-mode
          rust-ts-mode
          shell-script-mode
          dockerfile-mode
          dockerfile-ts-mode
          prog-mode
          yaml-mode
          yaml-ts-mode) . outli-mode)
  :init
  (require 'org))


(provide 'init-outli)
;;; init-outli.el ends here
