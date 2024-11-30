(my/straight-if-use 'expand-region)
(use-package expand-region
  :bind ( ("C-=" . er/expand-region)
          ("C--" . er/contract-region)))

(provide 'init-expand-region)
