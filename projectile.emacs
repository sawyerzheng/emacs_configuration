;; -*- coding: utf-8; -*-

;; tutorial: https://projectile.readthedocs.io/en/latest/usage/
(use-package projectile
  :ensure t)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


;; (eval-after-load 'projectile
;;   (setq-default
;;    projectile-mode-line
;;    '(:eval
;;      (if (file-remote-p default-directory)
;; 	 " Pr"
;;        (format " Pr[%s]" (projectile-project-name))))))

(setq projectile-mode-line-function
      '(lambda () (format " Proj[%s]" (projectile-project-name))))



;;================= helm-projectile =======================
;; (use-package helm-projectile
  ;; :ensure t)

;; (setq helm-projectile-fuzzy-match nil)
;; (require 'helm-projectile)
;; (helm-projectile-on)
