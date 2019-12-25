;; -*- coding: utf-8-unix; -*-
;; ============ ansi color to escape error correction =======
;; https://emacs.stackexchange.com/questions/8135/why-does-compilation-buffer-show-control-characters
(require 'ansi-color)
(defun my/ansi-colorize-buffer ()
  (let ((buffer-read-only nil))
    (ansi-color-apply-on-region (point-min) (point-max))))
(add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer)
