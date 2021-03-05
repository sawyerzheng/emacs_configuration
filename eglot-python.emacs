;; -*- coding: utf-8; -*-
;; https://github.com/palantir/python-language-server
;; install pyls
;; pip install 'python-language-server[all]'

(use-package eglot
  :ensure t
  :config
  (add-hook 'python-mode-hook 'eglot-ensure))

(add-hook 'python-mode-hook
	  (lambda ()
	    (local-unset-key (kbd "C-c C-n"))
	    (local-set-key (kbd "C-c C-n") 'flymake-goto-next-error)
	    (local-unset-key (kbd "C-c C-p"))
	    (local-set-key (kbd "C-c C-p") 'flymake-goto-prev-error)
	    (local-unset-key (kbd "C-c C-l"))
	    (local-set-key (kbd "C-c C-l") 'flymake-show-diagnostics-buffer)

	    ;; (local-unset-key (kbd "C - c SPC C - n"))
	    ;; (local-set-key (kbd "C") 'self-insert-command)
	    ))
