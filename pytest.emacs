;; -*- coding: utf-8; -*-
(use-package pytest
  :ensure t)

;; (add-to-list 'pytest-project-names "my/crazy/runner")
;; (add-to-list 'pytest-project-names "d:/soft/miniconda3/envs/py37/Scripts/py.test.exe")

(add-hook 'python-mode-hook
	  (lambda ()
	    ;; (local-unset-key (kbd "C-c a"))
	    (local-set-key "\C-ca" 'pytest-all)
	    (local-set-key "\C-cm" 'pytest-module)
	    (local-set-key "\C-c." 'pytest-one)
	    ;; (local-set-key "\C-cd" 'pytest-directory)
	    ;; (local-set-key "\C-cpa" 'pytest-pdb-all)
	    ;; (local-set-key "\C-cpm" 'pytest-pdb-module)
	    ))


;; --> to fix bugs
;; https://github.com/ionrock/pytest-el/issues/31
;; date: 2021.01.08
(defun pytest-cmd-format (&rest _) "pytest")
(defun pytest-find-test-runner () nil)
