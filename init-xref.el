(provide 'init-xref)

(use-package xref
  :bind (:map xref--xref-buffer-mode-map
              ("M-n" . xref-next-line)
              ("M-p" . xref-prev-line)))
