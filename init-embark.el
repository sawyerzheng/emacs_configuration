(my/straight-if-use 'embark)
(my/straight-if-use 'marginalia)
(my/straight-if-use 'embark-consult)

(use-package marginalia
  :demand t
  :config
  (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ;; ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :commands (embark-prefix-help-command
	      embark-dwim
	      embark-act
	      embark-bindings)
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))

  )

(use-package embark-consult
  ;; :straight t
  :after (embark consult)
  :demand t              ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
;; (with-eval-after-load 'vertico
;;   (require 'embark))

(provide 'init-embark)
