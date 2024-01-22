(use-package elisp-demos
  :straight t
  :commands (elisp-demos-advice-describe-function-1))

(use-package helpful
  :straight t
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

         )
  :config
  (require 'elisp-demos)
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update)
  )

;; (autoload 'helpful-mode "helpful")
;; (autoload 'helpful-mode-map "helpful")

;; (with-eval-after-load 'info
;;   (require 'info+))
(use-package info-plus
  :straight t
  :after info)


(provide 'init-helpful)
