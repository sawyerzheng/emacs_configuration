;; -*- coding: utf-8; *-
(use-package company
  ;; :ensure t
  ;; :defer 3
  :after (yasnippet)
  :delight
  (company-mode " CMP")
  :commands (company-mode company-indent-or-complete-common global-company-mode)
  ;; :hook ((my/startup . global-company-mode)
  ;; (prog-mode . company-mode))
  :bind (:map company-mode-map
              ("<tab>" . company-indent-or-complete-common)
              )
  :bind (:map company-active-map
              ("<tab>" . company-select-next-or-abort)
              ("<backtab>" . company-select-previous-or-abort))
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
;; (add-hook 'my/startup-hook 'global-company-mode)

;;================== for company-mode
;;http://company-mode.github.io/


;; for use company and yasnippet conflict

;;=============================================================

(provide 'init-company)
