;;; init-ghostel.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 sawyer
;;
;; Author: sawyer <sawyer@helium>
;; Maintainer: sawyer <sawyer@helium>
;; Created: June 03, 2026
;; Modified: June 03, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-ghostel
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package ghostel
  :defer t
  )

;; ghostel 的 semi-char 模式默认把 M-<可打印字符>（含 M-o、M-'）绑定为
;; `ghostel--send-event'，会遮蔽全局的 `my/ace-window' 和 rimel/pyim 的
;; `*-convert-string-at-point'。把这些键放进 exceptions，让它们落回
;; Emacs 键位；char 模式（C-c M-d）仍会原样发送给终端。
(with-eval-after-load 'ghostel
  (dolist (key '("M-o" "M-'" "C-\\"))
    (unless (member key ghostel-keymap-exceptions)
      (customize-set-variable 'ghostel-keymap-exceptions
                              (cons key ghostel-keymap-exceptions)))))

(provide 'init-ghostel)
;;; init-ghostel.el ends here
