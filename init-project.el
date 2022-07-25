(bind-key "C-c p" project-prefix-map)
(use-package project
  :defer t
  :config
  ;; (bind-key "o" #'+treemacs/toggle  project-prefix-map)
  (bind-key "o" #'dired-sidebar-toggle-sidebar  project-prefix-map)

  )

(use-package projectile
  :straight t
  :after project
  :bind (:map project-prefix-map
              ("P" . projectile-test-project)
              ("T" . projectile-find-test-file)
              ("t" . projectile-toggle-between-implementation-and-test)
              ("g" . projectile-find-file-dwim)
              ("a" . projectile-find-other-file)
              ("u" . projectile-run-project)
              ("v" . projectile-vc)))

(use-package project-x
  :straight (:type git :host github :repo "karthink/project-x")
  :after project
  :config
  (add-hook 'project-find-functions 'project-x-try-local 90))

(provide 'init-project)
