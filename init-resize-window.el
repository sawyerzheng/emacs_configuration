(use-package resize-window
  :straight t
  :bind ("C-:" . resize-window)
  :config
  (add-to-list 'resize-window-dispatch-alist '(?o resize-window--cycle-window-positive " Resize - cycle window" nil))
  (add-to-list 'resize-window-dispatch-alist '(?O resize-window--cycle-window-negative " Resize - cycle window" nil)))

(provide 'init-resize-window)
