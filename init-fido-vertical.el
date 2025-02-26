(use-package icomplete
  :commands (fido-vertical-mode
	     fido-mode
	     )
  :bind (:map icomplete-vertical-mode-minibuffer-map
              ("M-p" . #'icomplete-backward-completions)
              ("M-n" . #'icomplete-forward-completions)
              )
  )


(provide 'init-fido-vertical)
