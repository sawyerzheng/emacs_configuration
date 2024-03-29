(setq-default indent-tabs-mode nil)
(use-package dtrt-indent
  :straight t
  :hook (my/startup . dtrt-indent-global-mode))

(use-package aggressive-indent-mode
  :straight t
  :hook ((emacs-lisp-mode) . aggressive-indent-mode)
  :config
  ;; (global-aggressive-indent-mode 1)
  ;; (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
  )

(provide 'init-indent-tabs)
