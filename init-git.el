(setq my/git-everywhere nil)
(my/straight-if-use 'magit)
(use-package magit
  :bind ("C-x g" . magit-status)
  :commands (magit-file-delete magit-init)
  :config
  (setq magit-diff-refine-hunk 'all) ;; (nil t 'all) 显示单词级别的差异
  )

(my/straight-if-use 'transient)
(use-package transient
  :after magit
  )

;; (when (or my/git-everywhere (daemonp) t)
;;   (use-package forge
;;     :after (magit-remote magit)
;;     :straight t
;;     :bind (:map forge-topic-list-mode-map
;;                 ("q" . kill-current-buffer)))
;;   (use-package code-review
;;     :after magit
;;     :straight t)
;;   )

(my/straight-if-use 'magit-gitflow)
(use-package magit-gitflow
  :after magit
  :hook (magit-mode . turn-on-magit-gitflow))

(my/straight-if-use 'magit-todos)
(use-package magit-todos
  :after magit
  :config
  (setq magit-todos-keyword-suffix "\\(?:([^)]+)\\)?:?") ; make colon optional
  (define-key magit-todos-section-map "j" nil))

;; git gutter(git diff highlight)
(my/straight-if-use 'git-gutter)
(my/straight-if-use 'git-gutter-fringe)
(use-package git-gutter
  :hook (find-file . git-gutter-mode)
  :config
  ;; add beautiful support in GUI.
  (when (or (daemonp) (display-graphic-p))
    (use-package git-gutter-fringe
      :config
      (if my/4k-p
          (progn
            (setq-default left-fringe-width 20)
            (setq-default right-fringe-width 20))
        (progn
          (setq-default left-fringe-width 10)
          (setq-default right-fringe-width 10)))
      (setq git-gutter-fr:side 'left-fringe))))
(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'(lambda ()
                                                (unless (boundp 'git-gutter-mode)
                                                  (require 'git-gutter))))
  (add-hook 'my/startup-hook #'(lambda () (require 'git-gutter))))

(my/straight-if-use 'git-timemachine)
(use-package git-timemachine
  :commands (git-timemachine))



;; delta, `magit-diff-refine-hunk' variable as 'all can have similar effect
;; (use-package magit-delta
;;   :straight (:source (melpa))
;;   :hook (magit-mode . magit-delta-mode)
;;   :config
;;   (setq magit-delta-hide-plus-minus-markers t)
;;   (setq magit-delta-default-dark-theme "Monokai Extended")
;;   (setq magit-delta-default-dark-theme "Monokai Extended Darker")
;;   (setq magit-delta-default-dark-theme "Monokai Extended Bright")
;;   (setq magit-delta-default-dark-theme "1337")
;;   (setq magit-delta-default-dark-theme "Github")

;;   (setq magit-delta-delta-args `("--max-line-distance" "0.6"
;;                                  "--true-color" ,(if xterm-color--support-truecolor "always" "never")
;;                                  "--color-only"
;;                                  ;; "--line-numbers"
;;                                  ))

;;   )


(provide 'init-git)
