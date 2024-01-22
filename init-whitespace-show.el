(use-package whitespace4r
  :straight (:type git :host github :repo "twlz0ne/whitespace4r.el" )
  :commands (whitespace4r-mode)
  :config
  (progn
    (setq show-trailing-whitespace nil)
    (setq whitespace4r-style '(tabs hspaces zwspaces trailing))
    (setq whitespace4r-display-mappings `((space-mark      . [?·])
                                          (hard-space-mark . [?¤])
                                          (zero-width-space-mark . [?┆])
                                          (tab-mark        . [?- ?⟶])))))

(provide 'init-whitespace-show)
