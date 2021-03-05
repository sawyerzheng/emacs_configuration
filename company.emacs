;; -*- coding: utf-8; *-
(use-package company
  :ensure t)

;;================== for company-mode
;;http://company-mode.github.io/
(add-hook 'after-init-hook 'global-company-mode)

;; for use company and yasnippet conflict
(defun company-yasnippet-or-completion ()
  "Solve company yasnippet conflicts."
  (interactive)
  (let ((yas-fallback-behavior
	 (apply 'company-complete-common nil)))
    (yas-expand)))

(add-hook 'company-mode-hook
	  (lambda ()
	    (substitute-key-definition
	     'company-complete-common
	     'company-yasnippet-or-completion
	     company-active-map)))
;;=============================================================
