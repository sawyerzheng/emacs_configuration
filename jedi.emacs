;; -*- coding: utf-8-unix; -*-

(use-package jedi
  :ensure t)
(use-package company-jedi
  :ensure t)
(add-hook 'python-mode-hook 'jedi:setup)


;; (setq jedi:complete-on-dot t)                 ; optional
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


;; ================== for company-jedi =========================
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)
;;===================== end ====================================
