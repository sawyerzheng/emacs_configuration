;; -*- coding: utf-8-unix; -*-
;; ============ ansi color to escape error correction =======
;; https://emacs.stackexchange.com/questions/8135/why-does-compilation-buffer-show-control-characters
(use-package ansi-color
  :straight (:type built-in)
  :commands ansi-color-apply-on-region
  :hook (compilation-filter . my/ansi-colorize-buffer)
  :config
  (defun my/ansi-colorize-buffer ()
    (let ((buffer-read-only nil))
      (ansi-color-apply-on-region (point-min) (point-max)))))

(provide 'init-ansi-color)
