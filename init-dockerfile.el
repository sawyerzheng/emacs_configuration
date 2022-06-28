;; -*- coding: utf-8-dos; -*-
(use-package dockerfile-mode
  :straight t
  :mode (("Dockerfile.*\\'" . dockerfile-mode)
	 (".*Dockerfile\\'" . dockerfile-mode))
  ;; :config
  ;; (add-to-list 'auto-mode-alist '("Dockerfile.*\\'" . dockerfile-mode))
  ;; (add-to-list 'auto-mode-alist '(".*Dockerfile\\'" . dockerfile-mode))
  )

(provide 'init-dockerfile)
