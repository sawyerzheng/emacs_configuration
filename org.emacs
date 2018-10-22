(require 'org)

;; Source Code �ı�����
(setq org-src-fontify-natively t)

;;================ org agenda ====================
;; Ĭ�� Org Agenda �ļ�Ŀ¼
(setq org-agenda-files '("~/org"))

;; org agenda ��ݼ�
(global-set-key "\C-ca" 'org-agenda)

;; =============== org capture ====================
(setq org-default-notes-file (concat org-directory "~/notes.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "��������")
	 "* TODO  %t\n %?\n %i\n"
	 :empty-lines 1)))

(provide 'init-org)
