(use-package winner
  :straight (:type built-in)
  :init
  (setq winner-dont-bind-my-keys t)
  :hook (my/startup . winner-mode)
  :bind (("C-c w u" . winner-undo)
         ("C-c w r" . winner-redo))
  :config)

(use-package golden-ratio
  :straight t
  :commands (golden-ratio-mode)
  ;; :hook (my/startup . golden-ratio-mode)
  :config
  (add-to-list 'golden-ratio-extra-commands 'ace-window)
  (add-to-list 'golden-ratio-extra-commands 'winum-select-window-1)
  (add-to-list 'golden-ratio-extra-commands 'winum-select-window-2)
  (add-to-list 'golden-ratio-extra-commands 'winum-select-window-3)
  (add-to-list 'golden-ratio-extra-commands 'winum-select-window-4)
  (add-to-list 'golden-ratio-extra-commands 'winum-select-window-5)
  (add-to-list 'golden-ratio-extra-commands 'winum-select-window-6)
  (add-to-list 'golden-ratio-extra-commands 'winum-select-window-7)
  (add-to-list 'golden-ratio-extra-commands 'winum-select-window-8)
  (add-to-list 'golden-ratio-extra-commands 'winum-select-window-9)
  (add-to-list 'golden-ratio-extra-commands 'treemacs-select-window)

  ;; exclude blink-search
  (add-to-list 'golden-ratio-exclude-buffer-names " *blink search input*")
  ;; exclude lsp-bridge code action
  (add-to-list 'golden-ratio-exclude-buffer-regexp "\\.pyw?[[:alnum:]]\\{6\\}$")


  )

(provide 'init-window)
