(add-to-list 'load-path "/path/to/dash-at-point")
(autoload 'dash-at-point "dash-at-point"
  "Search the word at point with Dash." t nil)
(global-set-key "\C-cd" 'dash-at-point)

(add-to-list 'dash-at-point-mode-alist '(latex-mode . "latex"))

;;(add-hook 'rinari-minor-mode-hook
;;         (lambda () (setq dash-at-point-docset "rails")))
