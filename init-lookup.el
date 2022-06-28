(use-package online
  :straight (:type built-in)
  :bind (("C-c s o" . +lookup/online)
         ("C-c s O" . +lookup/online-select)))

(provide 'init-lookup)
