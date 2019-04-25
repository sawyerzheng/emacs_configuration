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
(require 'org-ac)

;; Make config suit for you. About the config item, eval the following sexp.
;; (customize-group "org-ac")
(org-ac/config-default)
;;============================================================
