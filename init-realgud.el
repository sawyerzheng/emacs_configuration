(provide 'init-realgud)


(use-package realgud
  :straight (:files ("*"))
  :defer t
  :config
  (defun my/realgud-set-default-directory-fn (old-fun &rest args)
    "advice function for `realgud:pdb'"
    (let* ((default-directory (my/get-project-root)))
      (apply old-fun args)))

  :hook (python-mode . (lambda ()
                         (advice-add 'realgud:pdb :around 'my/realgud-set-default-directory-fn)))
  )
