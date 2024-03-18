(provide 'init-calc)

(use-package casual
  :straight (:type git :host github :repo "kickingvegas/Casual")
  :bind (:map calc-mode-map
              ("C-o" . casual-main-menu)))
