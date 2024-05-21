(use-package paredit
  :straight (:source (melpa gpu-elpa-mirror))
  :hook ((python-base-mode) . paredit-mode)
  :hook (paredit-mode-hook . (lambda () (electric-indent-local-mode -1)))
  )

(provide 'init-paredit)
