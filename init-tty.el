(my/straight-if-use '(clipetty :source (melpa gpu-elpa-mirror)))
(use-package
  clipetty
  :if (not (display-graphic-p))
  :init
  (defun my/clipetty-startup-enable ()
    (interactive)
    (require 'clipetty)
    (run-with-timer 2 5 #'global-clipetty-mode))
  :hook (after-init-hook . my/clipetty-startup-enable))

(provide 'init-tty)
