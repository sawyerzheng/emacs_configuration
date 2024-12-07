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

(global-set-key (kbd "C-x C-z") 'zoom-window-zoom)
