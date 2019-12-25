;;=================== zeal-at-poin ======================

(use-package zeal-at-point
  :ensure t)

;; and plugin of zeal
;; 全局调用快捷键
(global-set-key "\C-cz" 'zeal-at-point)

;; for python
;;(add-to-list 'zeal-at-point-mode-alist '(latex-mode . "latex"))
;;(add-to-list 'zeal-at-point-mode-alist '(python-mode . ("python" "django")))
(add-hook 'python-mode-hook
	  (lambda () (setq zeal-at-point-docset '("python" "django"))))
(add-hook 'latex-mode
	  (lambda ()
	    ((setq zeal-at-point-docset '("latex")))))
