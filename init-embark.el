(when (featurep 'straight)
  (straight-use-package 'embark))
(use-package embark
  ;; :straight (:type git :host github :repo "oantolin/embark" :files ("*"))
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ;; ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))

  (when (featurep 'straight)
    (straight-use-package 'marginalia))

  (use-package marginalia
    ;; :straight t
    :demand t
    :config
    (marginalia-mode))

  (when (featurep 'straight)
    (straight-use-package 'embark-consult))

  (use-package embark-consult
    ;; :straight t
    :after (embark consult)
    :demand t              ; only necessary if you have the hook below
    ;; if you want to have consult previews as you move around an
    ;; auto-updating embark collect buffer
    :hook
    (embark-collect-mode . consult-preview-at-point-mode)))

(with-eval-after-load 'vertico
  (require 'embark))

(provide 'init-embark)
