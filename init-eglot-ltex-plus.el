;;; init-eglot-ltex-plus.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 sawyer
;;
;; Author: sawyer <sawyer@helium>
;; Maintainer: sawyer <sawyer@helium>
;; Created: May 14, 2026
;; Modified: May 14, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-eglot-ltex-plus
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package eglot-ltex-plus
  :hook (text-mode . (lambda ()
                       (require 'eglot-ltex-plus)
                       (eglot-ensure)))
  :init
  (setq eglot-ltex-plus-server-path "path/to/ltex-ls-XX.X.X/"
        eglot-ltex-plus-communication-channel 'stdio))         ; 'stdio or 'tcp

(provide 'init-eglot-ltex-plus)
;;; init-eglot-ltex-plus.el ends here
