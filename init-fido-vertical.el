(use-package icomplete
  :init
  (defun my/fido-use-orderless ()
    (when (and fido-vertical-mode
	       (featurep 'orderless))

      (setq-local completion-styles '(orderless))
      (setq-local icomplete-separator " ")
      (setq-local icomplete-hide-common-prefix nil)

      (define-key icomplete-fido-mode-map (kbd "SPC") #'self-insert-command)
      ))
  (add-hook 'minibuffer-setup-hook #'my/fido-use-orderless)
  :commands (fido-vertical-mode
	     fido-mode
	     )
  :bind (:map icomplete-vertical-mode-minibuffer-map
              ("M-p" . #'icomplete-backward-completions)
              ("M-n" . #'icomplete-forward-completions)
              )
  )


(provide 'init-fido-vertical)
