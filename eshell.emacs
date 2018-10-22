;; ========= shell ===========
;;(add-hook 'shell-mode-hook
;;	  (lambda ()
;;	    (eshell/source "/etc/bashrc" )))


;; ======== alias =============
(defun eshell/em (file)
  (find-file file))
(defun eshell/emacs (file)
  (find-file file))

;;================= for eshell unreadable code 乱码 ================
(defun ch-utf-language-environment()
  (set-language-environment 'UTF-8)
  )

(add-hook 'eshell-mode-hook 'ch-utf-language-environment)
;;==================================================================

;;========================= for windows shell ======================
;; for cmd
(if (eq system-type 'windows-nt) 
    (add-hook 'shell-mode-hook
	      (lambda()
		(set-language-environment 'Chinese-GB))))
;; for powershell
(if (eq system-type 'windows-nt) 
    (add-hook 'powershell-mode-hook
	      (lambda()
		(set-language-environment 'Chinese-GB))))
;;==================================================================
