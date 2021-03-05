;; -*- coding: utf-8-unix; -*-
(require 'org)

;; Source Code 文本高亮
(setq org-src-fontify-natively t)

;;================ org agenda ====================
;; 默认 Org Agenda 文件目录
(setq org-agenda-files '("~/org"))

;; org agenda 快捷键
(global-set-key "\C-ca" 'org-agenda)

;; =============== org capture ====================
(setq org-default-notes-file (concat org-directory "~/notes.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "工作安排")
	 "* TODO  %t\n %?\n %i\n"
	 :empty-lines 1)))

(provide 'init-org)

;;==============  for auto completion ========================
(use-package org-ac
  :ensure t)
(require 'org-ac)

;; Make config suit for you. About the config item, eval the following sexp.
;; (customize-group "org-ac")
(org-ac/config-default)
;;============================================================


;;=========== for source block execution =============
;;https://emacs.stackexchange.com/questions/17673/no-org-babel-execute-function-for-c-and-no-org-babel-execute-function-for-c
;; Here C --> for C, C++
(org-babel-do-load-languages
 'org-babel-load-languages 
 '((python . t) (C . t) )
 )

;;========= for auto fill mode =============================
;; 当达到fill-column 后，自动换行（auto-fill-mode）
(add-hook 'org-mode-hook '(lambda ()
			    "enable auto-fill-mode"
			    (auto-fill-mode 1)))


;;============= org table mode =========================
(add-hook 'message-mode-hook 'turn-on-orgtbl)

;;============= jump back ==================
(add-hook 'org-mode-hook (lambda ()
			   (local-set-key (kbd "C-c C-S-o") 'org-mark-ring-goto)))
