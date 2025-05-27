(my/straight-if-use 'elisp-demos)
(use-package elisp-demos
  :commands (elisp-demos-advice-describe-function-1))

(my/straight-if-use 'helpful)
(use-package helpful
  :defines (helpful-mode helpful-mode-map)
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h o" . helpful-symbol)
         ;; ("C-h F" . helpful-function)
         ([remap describe-function] . helpful-callable)
         ;; ([remap describe-function] . helpful-function)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-key] . helpful-key)
         ([remap describe-symbol] . helpful-symbol)
         ([remap describe-command] . helpful-command)
         )
  :config
  (require 'elisp-demos)
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update)
  )


(my/straight-if-use 'info-plus)
(use-package info+
  :after info)


(provide 'init-helpful)
