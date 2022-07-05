(use-package persp-mode
  :straight t
  :diminish
  :unless noninteractive
  :commands (persp-switch-to-buffer persp-mode)
  :defines (recentf-exclude)
  :init
  (setq persp-keymap-prefix (kbd "C-c <tab>"))
  (setq
   persp-nil-name "main"
   persp-set-last-persp-for-new-frames nil
   persp-kill-foreign-buffer-behaviour 'kill)
  :hook (after-init . persp-mode)
  :bind (:map persp-key-map
              ("<tab>" . persp-switch))
  :config
  ;; negative to disable auto resume
  (setq persp-auto-resume-time (if my/auto-restore-workspace
                                   1.0
                                 -1.0))
  (setq persp-save-dir (expand-file-name "workspaces/" my/etc-dir))

  ;; remove persp-save-dir from recentf
  (with-eval-after-load 'recentf
    (push persp-save-dir recentf-exclude))

  ;; Don't save dead or temporary buffers
  (add-hook 'persp-filter-save-buffers-functions
            (lambda (b)
              "Ignore dead and unneeded buffers."
              (or (not (buffer-live-p b))
                  (string-prefix-p " *" (buffer-name b)))))
  (add-hook 'persp-filter-save-buffers-functions
            (lambda (b)
              "Ignore temporary buffers."
              (let ((bname (file-name-nondirectory (buffer-name b))))
                (or (string-prefix-p ".newsrc" bname)
                    (string-prefix-p "magit" bname)
                    (string-prefix-p "COMMIT_EDITMSG" bname)
                    (string-prefix-p "Pfuture-Callback" bname)
                    (string-prefix-p "treemacs-persist" bname)
                    (string-match-p "\\.elc\\|\\.tar\\|\\.gz\\|\\.zip\\'" bname)
                    (string-match-p "\\.bin\\|\\.so\\|\\.dll\\|\\.exe\\'" bname))))))


;; Projectile integration
;; (use-package persp-mode-projectile-bridge
;;   :straight t
;;   :after (persp-mode projectile)
;;   :commands (persp-mode-projectile-bridge-find-perspectives-for-all-buffers
;;              persp-mode-projectile-bridge-kill-perspectives)
;;   :hook ((after-init . (lambda ()
;;                          (persp-mode-projectile-bridge-mode +1)))
;;          (persp-mode . persp-mode-projectile-bridge-mode)
;;          (persp-mode-projectile-bridge-mode
;;           .
;;           (lambda ()
;;             (if persp-mode-projectile-bridge-mode
;;                 (persp-mode-projectile-bridge-find-perspectives-for-all-buffers)
;;               (persp-mode-projectile-bridge-kill-perspectives)))))
;;   :init (setq persp-mode-projectile-bridge-persp-name-prefix "")
;;   :config
;;   (with-no-warnings
;;     ;; HACK: Allow saving to files
;;     (defun my-persp-mode-projectile-bridge-add-new-persp (name)
;;       (let ((persp (persp-get-by-name name *persp-hash* :nil)))
;;         (if (eq :nil persp)
;;             (prog1
;;                 (setq persp (persp-add-new name))
;;               (when persp
;;                 (set-persp-parameter 'persp-mode-projectile-bridge t persp)
;;                 (persp-add-buffer (projectile-project-buffers)
;;                                   persp nil nil)))
;;           persp)))
;;     (advice-add #'persp-mode-projectile-bridge-add-new-persp
;;                 :override #'my-persp-mode-projectile-bridge-add-new-persp)

;;     ;; HACK: Switch to buffer after switching perspective
;;     (defun my-persp-mode-projectile-bridge-hook-switch (&rest _args)
;;       (let* ((buf (current-buffer))
;;              (persp (persp-mode-projectile-bridge-find-perspective-for-buffer buf)))
;;         (when persp
;;           (when (buffer-live-p
;;                  persp-mode-projectile-bridge-before-switch-selected-window-buffer)
;;             (let ((win (selected-window)))
;;               (unless (eq (window-buffer win)
;;                           persp-mode-projectile-bridge-before-switch-selected-window-buffer)
;;                 (set-window-buffer
;;                  win persp-mode-projectile-bridge-before-switch-selected-window-buffer)
;;                 (setq persp-mode-projectile-bridge-before-switch-selected-window-buffer nil))))
;;           (persp-frame-switch (persp-name persp))

;;           (when (buffer-live-p buf)
;;             (switch-to-buffer buf)))))
;;     (advice-add #'persp-mode-projectile-bridge-hook-switch
;;                 :override #'my-persp-mode-projectile-bridge-hook-switch)))


(with-eval-after-load "persp-mode"
    (defvar persp-mode-projectile-bridge-before-switch-selected-window-buffer nil)

    ;; (setq persp-add-buffer-on-find-file 'if-not-autopersp)

    (persp-def-auto-persp "projectile"
      :parameters '((dont-save-to-file . t)
                    (persp-mode-projectile-bridge . t))
      :hooks '(projectile-before-switch-project-hook
               projectile-after-switch-project-hook
               projectile-find-file-hook
               find-file-hook)
      :dyn-env '((after-switch-to-buffer-adv-suspend t))
      :switch 'frame
      :predicate
      #'(lambda (buffer &optional state)
          (if (eq 'projectile-before-switch-project-hook
                  (alist-get 'hook state))
              state
            (and
             projectile-mode
             (buffer-live-p buffer)
             (buffer-file-name buffer)
             ;; (not git-commit-mode)
             (projectile-project-p)
             (or state t))))
      :get-name
      #'(lambda (state)
          (if (eq 'projectile-before-switch-project-hook
                  (alist-get 'hook state))
              state
            (push (cons 'persp-name
                        (concat ""
                                (with-current-buffer (alist-get 'buffer state)
                                  (projectile-project-name))))
                  state)
            state))
      :on-match
      #'(lambda (state)
          (let ((hook (alist-get 'hook state))
                (persp (alist-get 'persp state))
                (buffer (alist-get 'buffer state)))
            (case hook
              (projectile-before-switch-project-hook
               (let ((win (if (minibuffer-window-active-p (selected-window))
                              (minibuffer-selected-window)
                            (selected-window))))
                 (when (window-live-p win)
                   (setq persp-mode-projectile-bridge-before-switch-selected-window-buffer
                         (window-buffer win)))))

              (projectile-after-switch-project-hook
               (when (buffer-live-p
                      persp-mode-projectile-bridge-before-switch-selected-window-buffer)
                 (let ((win (selected-window)))
                   (unless (eq (window-buffer win)
                               persp-mode-projectile-bridge-before-switch-selected-window-buffer)
                     (set-window-buffer
                      win persp-mode-projectile-bridge-before-switch-selected-window-buffer)))))

              (find-file-hook
               (setcdr (assq :switch state) nil)))
            (if (case hook
                  (projectile-before-switch-project-hook nil)
                  (t t))
                (persp--auto-persp-default-on-match state)
              (setcdr (assq :after-match state) nil)))
          state)
      :after-match
      #'(lambda (state)
          (when (eq 'find-file-hook (alist-get 'hook state))
            (run-at-time 0.5 nil
                         #'(lambda (buf persp)
                             (when (and (eq persp (get-current-persp))
                                        (not (eq buf (window-buffer (selected-window)))))
                               ;; (switch-to-buffer buf)
                               (persp-add-buffer buf persp t nil)))
                         (alist-get 'buffer state)
                         (get-current-persp)))
          (persp--auto-persp-default-after-match state)))

    ;; (add-hook 'persp-after-load-state-functions
    ;;           #'(lambda (&rest args) (persp-auto-persps-pickup-buffers)) t)
    )

(provide 'init-persp-mode)