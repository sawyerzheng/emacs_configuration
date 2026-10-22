;;; init-claude-code-ide.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 sawyer
;;
;; Author: sawyer <sawyer@helium>
;; Maintainer: sawyer <sawyer@helium>
;; Created: August 29, 2025
;; Modified: August 29, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-claude-code-ide
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(use-package claude-code-ide
  :bind ("C-c i c" . claude-code-ide-menu) ;; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup) ;; Optionally enable Emacs MCP tools
  (when my/linux-p
    (setq claude-code-ide-terminal-backend 'ghostel))
  )

;; ghostel 的 semi-char 模式默认把 M-<可打印字符>（含 M-o）绑定为
;; `ghostel--send-event'，会遮蔽全局的 `my/ace-window'。把 M-o 放进
;; exceptions，让它落回 global-map；char 模式仍会发送给终端。
(with-eval-after-load 'ghostel
  (unless (member "M-o" ghostel-keymap-exceptions)
    (customize-set-variable 'ghostel-keymap-exceptions
                            (cons "M-o" ghostel-keymap-exceptions))))

(provide 'init-claude-code-ide)
;;; init-claude-code-ide.el ends here
