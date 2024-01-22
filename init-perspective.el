(use-package perspective
  :straight t
  :delight (persp-mode)
  :unless noninteractive
  :commands (persp-switch-to-buffer persp-mode)
  :init
  (setq persp-mode-prefix-key (kbd "C-c <tab>"))
  ;; (when my/auto-restore-workspace
  ;;     (add-hook 'my/startup-hook #' (lambda () (persp-state-load persp-state-default-file))))
  :hook ((my/startup . persp-mode)
         (kill-emacs . (lambda () (persp-state-save persp-state-default-file))))
  :bind (:map perspective-map
              ("<tab>" . persp-switch))
  :config
  ;; (require 'doom-workspace)
  (use-package persp-projectile
    :straight t
    :after projectile
    :commands (projectile-persp-switch-project)
    :demand t)

  (setq persp-autokill-buffer-on-remove 'kill-weak
        persp-reset-windows-on-nil-window-conf nil
        persp-nil-hidden t
        persp-auto-save-fname "autosave"
        persp-save-dir (expand-file-name "workspaces/" my/etc-dir)
        persp-set-last-persp-for-new-frames t
        persp-switch-to-added-buffer nil
        persp-kill-foreign-buffer-behaviour 'kill
        persp-remove-buffers-from-nil-persp-behaviour nil
        persp-auto-resume-time -1       ; Don't auto-load on startup
        persp-auto-save-opt (if noninteractive 0 1)) ; auto-save on kill
  (make-directory persp-save-dir t)
  (setq persp-state-default-file (expand-file-name "perspective-state.el" persp-save-dir))

  ;; ref: https://github.com/minad/consult/wiki#perspective
  (with-eval-after-load 'consult

    (defvar consult--source-perspective
      (list :name     "Perspective"
            :narrow   ?s
            :category 'buffer
            :state    #'consult--buffer-state
            :default  t
            :items    #'persp-get-buffer-names))

    (push consult--source-perspective consult-buffer-sources)))




(provide 'init-perspective)
