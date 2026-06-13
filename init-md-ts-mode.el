;;; init-md-ts-mode.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 sawyer
;;
;; Author: sawyer <sawyer@helium>
;; Maintainer: sawyer <sawyer@helium>
;; Created: June 12, 2026
;; Modified: June 12, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-md-ts-mode
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:



(with-eval-after-load 'md-ts-mode
  (defun my/md-ts--line-number-width ()
    "Return columns used by the line-number margin, or 0 if not shown."
    (if (bound-and-true-p display-line-numbers-mode)
        (or (ignore-errors (line-number-display-width 'columns)) 0)
      0))

  (defun my/md-ts--fontify-thematic-break-advice (orig-fn node override start end &rest args)
    (let* ((beg (treesit-node-start node))
           (node-end (treesit-node-end node))
           (width (max 3 (truncate (- (window-body-width) (my/md-ts--line-number-width) 1))))
           (rule (make-string width ?─)))
      (treesit-fontify-with-override beg node-end 'md-ts-delimiter
                                     override start end)
      (put-text-property beg node-end 'display rule))
    nil)

  (advice-add 'md-ts--fontify-thematic-break :around
              #'my/md-ts--fontify-thematic-break-advice)

  (defun my/md-ts--refontify-thematic-breaks (&rest _)
    (when (derived-mode-p 'md-ts-mode)
      (font-lock-flush)
      (font-lock-ensure)))

  (add-hook 'window-size-change-functions #'my/md-ts--refontify-thematic-breaks)
  (add-hook 'display-line-numbers-mode-hook #'my/md-ts--refontify-thematic-breaks)

  (when (locate-library "markdown-ts-mode")
    (add-hook 'markdown-ts-mode-hook (lambda () (run-hooks 'markdown-mode-hook)))
    )
  )


(provide 'init-md-ts-mode)
;;; init-md-ts-mode.el ends here
