;; -*- coding: utf-8-unix; -*-
;; ============ ansi color to escape error correction =======
;; https://emacs.stackexchange.com/questions/8135/why-does-compilation-buffer-show-control-characters
(my/straight-if-use '(ansi-color :type built-in))
(use-package ansi-color
  :commands ansi-color-apply-on-region
  :hook ((org-mode
	  org-babel-after-execute
	  compilation-filter
	  compilation-mode) . my/ansi-colorize-buffer)
  :config
  (defun my/ansi-colorize-buffer ()
    (let ((buffer-read-only nil))
      (ansi-color-apply-on-region (point-min) (point-max))))
  (add-hook 'org-babel-after-execute-hook #'my/ansi-colorize-buffer))

(provide 'init-ansi-color)
