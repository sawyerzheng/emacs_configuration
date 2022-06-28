(setq my/git-everywhere nil)

(use-package magit
  :bind ("C-x g" . magit-status)
  :straight t
  :commands (magit-file-delete)
  )

(when my/git-everywhere t
      (use-package forge
        :after magit
        :straight t
        :bind (:map forge-topic-list-mode-map
                    ("q" . kill-current-buffer)))
      (use-package code-review
        :after magit
        :straight t))

(use-package magit-gitflow
  :after magit
  :straight t
  :hook (magit-mode . turn-on-magit-gitflow))
(use-package magit-todos
  :after magit
  :straight t
  :config
  (setq magit-todos-keyword-suffix "\\(?:([^)]+)\\)?:?") ; make colon optional
  (define-key magit-todos-section-map "j" nil))

;; git gutter(git diff highlight)
(use-package git-gutter
  :hook (find-file . git-gutter-mode)
  :straight t
  :config
  ;; add beautiful support in GUI.
  (when (display-graphic-p)
    (use-package git-gutter-fringe
      :straight t
      :config
      (if my/4k-p
          (progn
            (setq-default left-fringe-width 20)
            (setq-default right-fringe-width 20))
        (progn
          (setq-default left-fringe-width 3)
          (setq-default right-fringe-width 3)))
      (setq git-gutter-fr:side 'left-fringe))))

(use-package git-timemachine
  :straight t
  :commands (git-timemachine))

(provide 'init-git)
