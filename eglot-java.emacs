;; -*- coding: utf-8; -*-
(use-package eglot
  :ensure t)

(defconst my/eclipse-jdt-home "/tmp/jdt-language-server-latest.tar/plugins/org.eclipse.equinox.launcher_1.5.200.v20180922-1751.jar")

(if (eq system-type 'windows-nt)
    (setq my/eclipse-jdt-home "D:/home/.emacs.d/.cache/lsp/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.5.700.v20200207-2156.jar")
  )

(defun my/eclipse-jdt-contact (interactive)
  (let ((cp (getenv "CLASSPATH")))
    (setenv "CLASSPATH" (concat cp ":" my/eclipse-jdt-home))
    (unwind-protect
	(eglot--eclipse-jdt-contact nil)
      (setenv "CLASSPATH" cp))))

(setcdr (assq 'java-mode eglot-server-programs) #'my/eclipse-jdt-contact)


(add-hook 'java-mode-hook 'eglot-ensure)
