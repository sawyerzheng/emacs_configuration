(use-package wttrin
  :straight t
  :commands (wttrin)
  :config
  (setq wttrin-default-cities '("Hefei")))

(use-package display-wttr
  :straight t
  :custom
  (display-wttr-format "2")
  (display-wttr-locations '("Hefei"))
  ;; (display-wttr-interval (* 60 60))
  :config
  (display-wttr-mode))

(use-package sunshine
  :straight t
  :commands (sunshine-forecast)
  :config
  (setq sunshine-units 'metric)
  (setq sunshine-appid    "df5e1f2dffb1fb7d006a89dfe00e2905")
  (setq sunshine-location "Hefei,CN"))

(provide 'init-wttrin)
