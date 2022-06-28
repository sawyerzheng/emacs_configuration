;;; transparency.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Sawyer Zheng
;;
;; Author: Sawyer Zheng <https://github.com/sawyerzheng>
;; Maintainer: Sawyer Zheng <kmxsz@qq.com>
;; Created: 十二月 14, 2021
;; Modified: 十二月 14, 2021
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/transparency
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;  ref: https://www.emacswiki.org/emacs/TransparentEmacs
;;
;;; Code:
;;;###autoload
(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(90 . 50) '(100 . 100)))))

(provide 'transparency)
;;; transparency.el ends here
