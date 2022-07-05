;; -*- coding: utf-8; -*-
(use-package sky-color-clock
  :straight (sky-color-clock :type git :host github :repo "zk-phi/sky-color-clock")
  :config
  ;; location.
  (sky-color-clock-initialize 31.86) ;; Hefei city 31.86

  ;; mode line string
  (push '(:eval (sky-color-clock)) (default-value 'mode-line-format))

  ;; City's ID to search weather
  (sky-color-clock-initialize-openweathermap-client
   "df5e1f2dffb1fb7d006a89dfe00e2905" ;; api key
   "1808722" 			      ;; city id
   ;; "Hefei,CN"
   )



  ;; time format, using `format-time-string'
  (setq sky-color-clock-format "%d %H:%M")

  ;; Moon phase
  ;; (setq sky-color-clock-enable-emoji-icon t)

  ;; temperature indicator
  ;; (setq sky-color-clock-enable-temperature-indicator t)
  )

(provide 'init-sky-color-clock)
