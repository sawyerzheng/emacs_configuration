;; -*- coding: utf-8; -*-

(load-file "~/.conf.d/elpy.emacs")
;; (load-file "~/.conf.d/jedi.emacs")
;;(load-file "~/.conf.d/anaconda.emacs")

(define-key python-mode-map  [(tab)] 'company-indent-or-complete-common)
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

;;======================== indent
;; (add-hook 'python-mode-hook
;; 		  (lambda ()
;; 		    (setq-default indent-tabs-mode t)
;; 		    (setq-default tab-width 4)
;; 		    (setq-default py-indent-tabs-mode t)
;; 			(add-to-list 'write-file-functions 'delete-trailing-whitespace)))
;;===================================================================
;; for pdg
(setq gud-pdb-command-name "python -m pdb")

;;======================= virtualenvwrapper ====================
(use-package virtualenvwrapper
  :ensure t)
(require 'virtualenvwrapper)
(venv-initialize-eshell)
(venv-initialize-eshell)
;;(setq venv-location '("/home/sawyer/.virtualenvs"
;;		     "/home/sawyer/anaconda3/envs/"))
(if (eq system-type 'windows-nt)
    (setq venv-location "d:/soft/.virtualenvs.d/")
  (setq venv-location "/home/sawyer/.virtualenvs"))
;;=====================  end virtualenvwrapper ==================

;;========= virtual env  ==================
;; (pyvenv-workon "env36")
;; (pyvenv-activate "/home/sawyer/miniconda3/envs/py36")
