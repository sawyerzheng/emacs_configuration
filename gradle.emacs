;; -*- coding: utf-8-unix; -*-
(require 'gradle-mode)
(add-hook 'java-mode-hook '(lambda() (gradle-mode 1)))

;;========== .gradle file template ==================
;; apply plugin: 'java'
;; apply plugin: 'application'

;; mainClassName = "Test"

;; applicationDefaultJvmArgs = ["-ea"]


;;============== compile and run =====================
(defun build-and-run ()
	(interactive)
	(gradle-run "build run"))

(define-key gradle-mode-map (kbd "C-c C-r") 'build-and-run)
