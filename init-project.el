(bind-key "C-c p" project-prefix-map)
(use-package project
  ;; :defer t
  :straight (:type built-in)
  :config
  ;; (bind-key "o" #'+treemacs/toggle  project-prefix-map)
  (bind-key "o" #'dired-sidebar-toggle-sidebar project-prefix-map)
  (defun project--find-in-directory (dir)
    (run-hook-with-args-until-success 'project-find-functions (file-truename dir))))

(defun my/project-vterm ()
  "start a vterm shell buffer for current project"
  (interactive)
  (let* ((default-directory (project-root (project-current t)))
         (project-shell-name (project-prefixed-buffer-name "vterm"))
         (shell-buffer (get-buffer project-shell-name))
         (vterm-buffer-name project-shell-name))

    (unless (buffer-live-p shell-buffer)
      (unless (require 'vterm nil 'noerror)
        (error "Package 'vterm' is not available"))
      (vterm-other-window project-shell-name))
    (switch-to-buffer project-shell-name)))

(defun my/project-eat ()
  "start a eat shell buffer for current project"
  (interactive)
  (let* ((default-directory (project-root (project-current t)))
         (project-shell-name (project-prefixed-buffer-name "eat"))
         (shell-buffer (get-buffer project-shell-name))
         (eat-buffer-name project-shell-name))

    (unless (buffer-live-p shell-buffer)
      (unless (require 'eat nil 'noerror)
        (error "Package 'eat' is not available"))
      (eat-other-window))
    (switch-to-buffer project-shell-name)))

(use-package projectile
  :straight t
  ;; :after project
  :bind (:map project-prefix-map
              ("P" . projectile-test-project)
              ("T" . projectile-find-test-file)
              ("t" . projectile-toggle-between-implementation-and-test)
              ("g" . projectile-find-file-dwim)
              ("a" . projectile-find-other-file)
              ("u" . projectile-run-project)
              ("v" . projectile-vc)
              ("b" . consult-project-buffer)
              ("x" . nil)
              ("x c" . project-shell-command)
              ("x a" . project-async-shell-command)
              ("x E" . project-execute-extended-command)
              ("x x" . my/project-eat)
              ("x v" . my/project-vterm)
              ("x e" . project-eshell)
              ("x s" . project-shell)
              ("x t" . my/project-eat)
              )
  ;; :bind-keymap ("C-x p" . projectile-command-map)
  )



(bind-key "C-x p" nil)
(autoload 'projectile-command-map "projectile")
(bind-key "C-x p" 'projectile-command-map)


(use-package project-x
  :straight (:type git :host github :repo "karthink/project-x")
  :after project
  :config
  (add-hook 'project-find-functions 'project-x-try-local 90))

(provide 'init-project)
