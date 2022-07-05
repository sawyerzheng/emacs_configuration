(use-package helpful
  :straight t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h o" . helpful-symbol)
         ("C-h F" . helpful-function))
  :config
  (require 'elisp-demos)
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update)
  )

(with-eval-after-load 'info
  (require 'info+))


(provide 'init-helpful)
