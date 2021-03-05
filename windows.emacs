;; -*- coding: utf-8; -*-

;; cmd.exe
(defun run-cmdexe ()
      (interactive)
      (let ((shell-file-name "cmd.exe"))
	    (shell "*cmd.exe*")))

;; utf-8 anywhere
(setq-default buffer-file-coding-system 'utf-8)

(set-terminal-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)

;; bell
(setq-default visible-bell t)
