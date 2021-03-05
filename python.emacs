;; -*- coding: utf-8; -*-
;; (use-package python-mode
  ;; :ensure t)
;; (require 'python)
(load-file "~/.conf.d/python-basic.emacs")
(load-file "~/.conf.d/flycheck-python.emacs")
;; (load-file "~/.conf.d/elpy.emacs")
;; (load-file "~/.conf.d/eglot-python.emacs")
(load-file "~/.conf.d/lsp-python.emacs")
;; (load-file "~/.conf.d/jedi.emacs")
;;(load-file "~/.conf.d/anaconda.emacs")
(load-file "~/.conf.d/dap.emacs")



;; ====================== debug, dap =================
;; pip install ptvsd
(require 'dap-python)


(define-key python-mode-map  [(tab)] 'company-indent-or-complete-common)

;;======================== indent
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq python-indent-offset 4)
	    (setq indent-tabs-mode nil)
	    (setq tab-width 4)
	    ;; (setq py-indent-tabs-mode t)
	    ;; 	(add-to-list 'write-file-functions 'delete-trailing-whitespace)
	    ))
;;===================================================================
;; for pdg
(setq gud-pdb-command-name "python -m pdb")

;;======================= virtualenvwrapper ====================
(use-package virtualenvwrapper
  :ensure t)
(require 'virtualenvwrapper)
(venv-initialize-eshell)
;;(setq venv-location '("/home/sawyer/.virtualenvs"
;;		     "/home/sawyer/anaconda3/envs/"))

(if (eq system-type 'windows-nt)
    ;; (setq venv-location "d:/soft/envs")
  (setq venv-location "c:/soft/envs")
  )
  ;; (setq venv-location "/home/sawyer/.virtualenvs"))
;;=====================  end virtualenvwrapper ==================

;;========= virtual env  ==================
;; (pyvenv-workon "env36")
;; (pyvenv-activate "/home/sawyer/miniconda3/envs/py36")

