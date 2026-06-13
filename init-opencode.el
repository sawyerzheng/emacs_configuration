;;; init-opencode.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 sawyer
;;
;; Author: sawyer <sawyer@helium>
;; Maintainer: sawyer <sawyer@helium>
;; Created: January 21, 2026
;; Modified: January 21, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-opencode
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package opencode
  :commands (opencode))

(when my/doom-p
  (map! :after opencode
        :map opencode-session-mode-map
        :localleader
        "C-c" #'opencode-abort-session
        "C-y" #'opencode-yank-code-block
        "F" #'opencode-fork-session
        "M" #'opencode-toggle-mcp
        "R" #'opencode-revert-message
        "U" #'opencode-unshare-all-sessions
        "b" #'opencode-add-buffer
        "c" #'opencode-select-child-session
        "f" #'opencode-add-file
        "m" #'opencode-select-model
        "n" #'opencode-new-session
        "p" #'opencode-open-parent
        "r" #'opencode-rename-session
        "s" #'opencode-share-session
        "u" #'opencode-unshare-session
        "v" #'opencode-select-variant
        "x" #'opencode-kill-session
        )
  )

(provide 'init-opencode)
;;; init-opencode.el ends here
