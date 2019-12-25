;; -*- coding: utf-8-unix; -*-
;; tutorial: http://www.goldsborough.me/emacs,/java/2016/02/24/22-54-16-setting_up_emacs_for_java_development/
;; =================== sub modules ===================
(load-file "~/.conf.d/gradle.emacs")



(use-package eclim
  :ensure t)
(use-package company-emacs-eclim
  :ensure t)
(use-package ac-emacs-eclim
  :ensure t)

;;===================== customize eclim itself ===================
(require 'eclimd)

(require 'eclim)
(setq eclimd-autostart t)

(defun my-java-mode-hook ()
  (eclim-mode t))

(add-hook 'java-mode-hook 'my-java-mode-hook)

;; ==================== some commands =============================
;; start-eclimd
;; eclimd-executable


;; eclim-project-create
;; eclim-project-open

;; eclim-java-refactor-rename-symbol-at-point


;;==================== company mode ===================
(require 'company)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(global-company-mode t)
;;==============================================================

;; syntax
(define-key eclim-mode-map (kbd "C-c C-c") 'eclim-problems-correct)

;; exclim executable
(customize-set-variable 'eclim-executable "/opt/eclipse/plugins/org.eclim_2.8.0/bin/eclim")
