(provide 'init-zoom)

(my/straight-if-use 'zoom-window)

(use-package zoom-window
  :bind (("C-c l z" . zoom-window-zoom))
  :config
  (custom-set-variables
   '(zoom-window-use-persp t))
  (zoom-window-setup)
  )
(require 'zoom-window)
(custom-set-variables
 '(zoom-window-use-persp t))


(zoom-window-setup)
(setq zoom-window-mode-line-color "black")
(defun my/zoom-window-after-theme-load-advice (&rest args)
  (setq zoom-window--orig-color (face-background 'mode-line))
  )

(advice-add 'load-theme :after #'my/zoom-window-after-theme-load-advice)

(global-set-key (kbd "C-x C-z") 'zoom-window-zoom)
