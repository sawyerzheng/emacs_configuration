;;; init-claudemacs.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 sawyer
;;
;; Author: sawyer <sawyer@helium>
;; Maintainer: sawyer <sawyer@helium>
;; Created: November 11, 2025
;; Modified: November 11, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-claudemacs
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package claudemacs
  :init
  (require 'init-eat)
  :bind ("C-c i m" . claudemacs-transient-menu) ; Set your favorite keybinding
  :commands (claudemacs-transient-menu))

;; Set a big buffer so we can search our history.
(with-eval-after-load 'eat
  (setq eat-term-scrollback-size 400000))

;; If you want it to pop up as a new buffer. Otherwise, it will use "other buffer."
;; Personally, I use the default "other buffer" style.
(add-to-list 'display-buffer-alist
             '("^\\*claudemacs"
               (display-buffer-in-side-window)
               (side . right)
               (window-width . 0.33)))
(provide 'init-claudemacs)
;;; init-claudemacs.el ends here
