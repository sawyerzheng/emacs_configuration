;; -*- coding: utf-8; *-
(use-package company
  ;; :ensure t
  ;; :defer 3
  :after (yasnippet)
  :delight
  (company-mode " CMP")
  :commands (company-mode company-indent-or-complete-common global-company-mode)
  :hook ((after-init . global-company-mode)
		 (prog-mode . company-mode))
  :config

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

  )

(use-package company-box
  :straight (company-box)
  :hook (company-mode . company-box-mode))

;; (load-file "~/.conf.d/tabnine.emacs")
;; (add-hook 'after-init-hook 'global-company-mode)

;;================== for company-mode
;;http://company-mode.github.io/


;; for use company and yasnippet conflict

;;=============================================================

(provide 'init-company)
