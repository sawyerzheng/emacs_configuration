;;; init-hugo-blog.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: July 29, 2025
;; Modified: July 29, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-hugo-blog
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
(defun my/hugo-org-update-timestamp ()
  (interactive)
  (when (derived-mode-p 'org-mode)
    (let ((time-stamp-active t)
          (time-stamp-start "#\\+lastmod:[ \t]*")
          (time-stamp-end "$")
          (time-stamp-format "[%04Y-%02m-%02d %a]")
          (time-stamp-format "[%Y-%02m-%02d %a %02H:%02M:%02S]")
          )
      (time-stamp))))
(with-eval-after-load 'org
  (add-hook 'after-save-hook #'my/hugo-org-update-timestamp nil))


(provide 'init-hugo-blog)
;;; init-hugo-blog.el ends here
