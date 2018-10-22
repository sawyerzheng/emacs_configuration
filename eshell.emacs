;; ========= shell ===========
;;(add-hook 'shell-mode-hook
;;	  (lambda ()
;;	    (eshell/source "/etc/bashrc" )))


;; ======== alias =============
(defun eshell/em (file)
  (find-file file))
(defun eshell/emacs (file)
  (find-file file))
