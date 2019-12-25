;; -*- coding: utf-8; -*-

;;=================== Key binding =======================
;; Ctr-c v ---> save html and browse it.
(defun my-html-validate-function()
  "Save the html file before validating it.
(Save it and browse it.)"
  (interactive)
  (save-buffer)
  (browse-url-of-buffer)
  )
(defun my-html-mode-hook()
  (local-set-key "\C-cv" 'my-html-validate-function)
  )
(add-hook 'html-mode-hook 'my-html-mode-hook)
