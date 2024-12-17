(my/straight-if-use 'poporg)
(use-package poporg
  :bind (:map prog-mode-map
              ("C-c '" . poporg-dwim))
  :bind (:map poporg-mode-map
              ("C-c '" . poporg-dwim))
  :config
  (setq poporg-edit-hook '(org-mode my-poporg-tune-org-fun))
  (defun my-poporg-tune-org-fun ()
    (org-indent-mode -1)
    (setq-local org-adapt-indentation t)
    (setq-local org-edit-src-content-indentation 0)
    (setq-local org-src-preserve-indentation t)
    (setq-local org-indent-indentation-per-level 2))
  ;; (add-hook 'poporg-edit-hook #'my-poporg-tune-org-fun)
  (add-hook 'org-mode-hook #'(lambda () (when (and (featurep 'poporg) poporg-mode)
                                          (org-indent-mode -1)))))

(provide 'init-poporg)
