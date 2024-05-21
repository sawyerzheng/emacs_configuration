(use-package paredit
  :straight (:source (melpa gpu-elpa-mirror))
  :hook ((python-base-mode) . paredit-mode)
  )

(provide 'init-paredit)
