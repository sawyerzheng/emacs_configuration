(provide 'init-realgud)


(use-package realgud
  :defer t
  :config
  (defun my/realgud-set-default-directory-fn (old-fun &rest args)
    "advice function for `realgud:pdb'"
    (let* ((default-directory (my/get-project-root)))
      (apply old-fun args)))
  (with-eval-after-load 'python
    (advice-add 'realgud:pdb :around 'my/realgud-set-default-directory-fn)))
