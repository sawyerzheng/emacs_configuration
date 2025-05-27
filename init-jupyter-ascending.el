(provide 'init-jupyter-ascending)

(my/straight-if-use '(jupyter-ascending :type git :host github :repo "Duncan-Britt/jupyter-ascending"))



(use-package jupyter-ascending
  :hook (python-base-mode . (lambda ()
                              (when (and buffer-file-name
					 (string-match-p "\\.sync\\.py\\'" buffer-file-name))
				(jupyter-ascending-mode 1))))
  :bind (:map jupyter-ascending-mode-map
              ("C-c C-k" . jupyter-ascending-execute-line)
              ("C-c C-a" . jupyter-ascending-execute-all)
              ("C-c C-n" . jupyter-ascending-next-cell)
              ("C-c C-p" . jupyter-ascending-previous-cell)
              ("C-c C-t" . jupyter-ascending-cycle-cell-type)
              ("C-c C-'" . jupyter-ascending-edit-markdown-cell)))
