;; -*- coding: utf-8; -*-
(require 'sky-color-clock)

;; location.
(sky-color-clock-initialize 31.86) ;; Hefei city 31.86

;; mode line string
(push '(:eval (sky-color-clock)) (default-value 'mode-line-format))

;; City's ID to search weather
(sky-color-clock-initialize-openweathermap-client "API-Key" 1808722)
					; Hefei's City ID


;; time format, using `format-time-string'
(setq sky-color-clock-format "%d %H:%M")

;; Moon phase
(setq sky-color-clock-enable-emoji-icon t)

;; temperature indicator
(setq sky-color-clock-enable-temperature-indicator t)
