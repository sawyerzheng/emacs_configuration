;; -*- coding: utf-8; -*-

;; tutorial: https://projectile.readthedocs.io/en/latest/usage/
(use-package projectile
  :straight t
  :commands projectile-mode
  :bind (
         ("C-c p" . projectile-command-map)
         ;; find file in other project
         ("C-c f o" . projectile-switch-project))

  :hook (my/startup . projectile-mode)
  :config
  (projectile-mode +1)  
  
  (setq projectile-mode-line-function
	'(lambda () (format " Proj[%s]" (projectile-project-name))))

  (setq projectile-completion-system 'auto)

  ;; projectile itself(`.projectile') is not good
  ;; use `.gitignore' file and `hybrid' is better
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching nil)

  (defun projectile-shell-open-at-project-root ()
    (interactive)
    (setq default-directory (projectile-project-root))
    (shell (format "*Shell[%s]*" (projectile-project-name))))
  )

(provide 'init-projectile)
