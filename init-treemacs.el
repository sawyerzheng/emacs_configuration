;; -*- coding: utf-8-unix; -*-
;; https://github.com/Alexander-Miller/treemacs
(use-package treemacs
  :commands (treemacs-mode treemacs treemacs-select-window)
  ;; :bind ("C-c o p" . +treemacs/toggle)
  :config
  (with-eval-after-load 'persp-mode
    :config
    (use-package treemacs-persp)
    )
  :init
  ;; code free doom emacs
  (defun doom-project-p (&optional dir)
    "Return t if DIR (defaults to `default-directory') is a valid project."
    (and (doom-project-root dir)
         t))
  (defun doom-project-root (&optional dir)
    "Return the project root of DIR (defaults to `default-directory').
Returns nil if not in a project."
    (if (featurep 'projectile)
        (let ((projectile-project-root
               (unless dir (bound-and-true-p projectile-project-root)))
              projectile-require-project-root)
          (projectile-project-root dir))
      (project-root (project-current)))
    )

  (defun +treemacs/toggle ()
    "Initialize or toggle treemacs.

Ensures that only the current project is present and all other projects have
been removed.

Use `treemacs' command for old functionality."
    (interactive)
    (require 'treemacs)
    (pcase (treemacs-current-visibility)
      (`visible (delete-window (treemacs-get-local-window)))
      (_ (if (doom-project-p)
             (treemacs-add-and-display-current-project)
           (treemacs)))))

  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))

  :bind
  (:map global-map
        ;; ("M-0"       . treemacs-select-window)
        ("C-x t 1" . treemacs-delete-other-windows)
        ("C-x t t" . treemacs)
        ("C-x t B" . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  :config
  (use-package treemacs-evil
    :after treemacs evil
    :hook (treemacs-mode . (lambda ()
                             (with-eval-after-load "treemacs"
                               (require 'treemacs-evil))))
    :bind (:map evil-motion-state-map
                ("n" . nil)))

  (use-package treemacs-magit
    :after treemacs magit
    :hook (magit-mode . (lambda ()
                          (with-eval-after-load "treemacs"
                            (require 'treemacs-magit)))))

  (use-package treemacs-projectile
    :after treemacs projectile
    :hook (treemacs-mode . (lambda ()
                             (with-eval-after-load "treemacs"
                               (require 'treemacs-projectile))))))
(use-package treemacs-nerd-icons
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))

(provide 'init-treemacs)
