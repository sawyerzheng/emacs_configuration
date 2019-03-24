(load-file "~/.conf.d/elpy.emacs")
;;(load-file "~/.conf.d/anaconda.emacs")

;; ================== for company-jedi =========================
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)
;;===================== end ====================================

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

;; for pdg
(setq gud-pdb-command-name "python -m pdb")


;;=================== for jedi =================================

(setq jedi:complete-on-dot t)                 ; optional
;;(when (fboundp 'jedi:setup) (jedi:setup))

;; my add
;;http://tkf.github.io/emacs-jedi/latest/
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional
;; setup
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
;; for keybindings
;;http://tkf.github.io/emacs-jedi/latest/index.html#keybinds
;;==============================================================


;;======================= virtualenvwrapper ====================
(require 'virtualenvwrapper)
(venv-initialize-eshell)
(venv-initialize-eshell)
;;(setq venv-location '("/home/sawyer/.virtualenvs.d/"
;;		     "/home/sawyer/anaconda3/envs/"))
(setq venv-location "/home/sawyer/.virtualenvs.d/")
;;=====================  end virtualenvwrapper ==================
