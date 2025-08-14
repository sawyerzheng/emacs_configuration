;;; init-envrc.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: August 12, 2025
;; Modified: August 12, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-envrc
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package envrc
  :commands (envrc-mode
             envrc-global-mode))

(unless my/doom-p
  (add-hook 'my/startup-hook #'envrc-global-mode))

(provide 'init-envrc)
;;; init-envrc.el ends here
