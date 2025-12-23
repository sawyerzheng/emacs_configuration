(provide 'init-meow-core)

;;;###autoload
(defun my/meow-quit (&optional arg)
  "Quit current window or buffer."
  (interactive "P")
  (cond
   ((derived-mode-p 'lsp-bridge-ref-mode) (lsp-bridge-ref-quit))
   (t (call-interactively #'meow-quit))))
