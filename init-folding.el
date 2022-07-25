(provide 'init-folding)

;; (use-package yafolding
;;   :straight t
;;   :hook (python-mode . yafolding-mode))

(use-package origami
  :straight t
  :bind (:map origami-mode-map
              ("C-<return>" . origami-recursively-toggle-node)
              ("C-S-<return>" . origami-close-node-recursively)
              ("C-M-<return>" . origami-toggle-all-nodes))
  :hook ((prog-mode) . origami-mode)
  )
