(use-package winner
  :straight (:type built-in)
  :init
  (setq winner-dont-bind-my-keys t)
  :hook (after-init . winner-mode)
  :bind (("C-c w u" . winner-undo)
         ("C-c w r" . winner-redo))
  :config)

(provide 'init-window)
