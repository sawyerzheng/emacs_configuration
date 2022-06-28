;; -*- coding: utf-8; -*-
;; dependency: npm i -g vmd
(use-package vmd-mode
  :ensure t
  :config
  (defun vmd-company-backend (command &optional arg &rest ignored)
    (interactive (list 'interactive))

    (cl-case command
      (interactive (company-begin-backend 'company-sample-backend))
      (prefix (and (eq major-mode 'fundamental-mode)
		   (company-grab-symbol)))
      (candidates
       (cl-remove-if-not
	(lambda (c) (string-prefix-p arg c))
	vmd-mode/github-emojis-list))))

  (add-to-list 'company-backends 'vmd-company-backend)

  (add-hook 'markdown-mode-hook 'vmd-mode))

(provide 'init-vmd)
