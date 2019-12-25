;; -*- coding: utf-8-unix; -*-
(add-to-list 'load-path "~/.conf.d/extra.d/")

(custom-set-variables
 '(livedown-autostart nil) ; automatically open preview when opening markdown files
 '(livedown-open t)        ; automatically open the browser window
 '(livedown-port 1337)     ; port for livedown server
 '(livedown-browser nil))  ; browser to use
(require 'livedown)
