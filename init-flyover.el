;;; init-flyover.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: August 05, 2025
;; Modified: August 05, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-flyover
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package flyover
  ;; :hook ((flycheck-mode
  ;;         flymake-mode) . flyover-mode)
  :commands (flyover-mode
             flyover-toggle)
  :config
  ;; Configure which error levels to display
  ;; Possible values: error, warning, info
  (setq flyover-levels '(error warning info))  ; Show all levels
  ;; (setq flyover-levels '(error warning))    ; Show only errors and warnings
  ;; (setq flyover-levels '(error))            ; Show only errors

;;; theming integration
  ;; Use theme colors for error/warning/info faces
  (setq flyover-use-theme-colors t)

  ;; Adjust background lightness (lower values = darker)
  (setq flyover-background-lightness 45)

  ;; Make icon background darker than foreground
  (setq flyover-percent-darker 40)

  (setq flyover-text-tint 'lighter) ;; or 'darker or nil

  ;; "Percentage to lighten or darken the text when tinting is enabled."
  (setq flyover-text-tint-percent 50)
  )

(provide 'init-flyover)
;;; init-flyover.el ends here
