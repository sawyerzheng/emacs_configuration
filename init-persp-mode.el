(my/straight-if-use 'persp-mode)
(defvar my/persp-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") #'persp-next)
    (define-key map (kbd "p") #'persp-prev)
    (define-key map (kbd "s") #'persp-frame-switch)
    (define-key map (kbd "S") #'persp-window-switch)
    (define-key map (kbd "r") #'persp-rename)
    (define-key map (kbd "c") #'persp-copy)
    (define-key map (kbd "C") #'persp-kill)
    (define-key map (kbd "z") #'persp-save-and-kill)
    (define-key map (kbd "a") #'persp-add-buffer)
    (define-key map (kbd "b") #'persp-switch-to-buffer)
    (define-key map (kbd "t") #'persp-temporarily-display-buffer)
    (define-key map (kbd "i") #'persp-import-buffers)
    (define-key map (kbd "I") #'persp-import-win-conf)
    (define-key map (kbd "k") #'persp-remove-buffer)
    (define-key map (kbd "K") #'persp-kill-buffer)
    (define-key map (kbd "w") #'persp-save-state-to-file)
    (define-key map (kbd "W") #'persp-save-to-file-by-names)
    (define-key map (kbd "l") #'persp-load-state-from-file)
    (define-key map (kbd "L") #'persp-load-from-file-by-names)
    (define-key map (kbd "o") (lambda ()
				(interactive)
				(persp-mode -1)))
    map)
  )


(global-set-key (kbd "C-c s") my/persp-mode-map)

(use-package persp-mode
  :unless noninteractive
  :commands (persp-switch-to-buffer
	     persp-mode
	     persp-switch
	     persp-frame-switch
	     persp-next
	     persp-prev
	     persp-frame-switch
	     persp-window-switch
	     persp-rename
	     persp-copy
	     persp-kill
	     persp-save-and-kill
	     persp-add-buffer
	     persp-switch-to-buffer
	     persp-temporarily-display-buffer
	     persp-import-buffers
	     persp-import-win-conf
	     persp-remove-buffer
	     persp-kill-buffer
	     persp-save-state-to-file
	     persp-save-to-file-by-names
	     persp-load-state-from-file
	     persp-load-from-file-by-names
	     )
  :defines (recentf-exclude)
  :init
  
  (autoload 'persp-key-map "persp-mode.el" nil t)

  ;; (setq persp-keymap-prefix (kbd "C-c s"))
  (setq
   persp-nil-name "main"
   persp-set-last-persp-for-new-frames nil
   persp-kill-foreign-buffer-behaviour 'kill)
  :hook (window-setup . persp-mode)
  :bind (:map my/persp-mode-map
	      ("TAB" . persp-switch)
	      ("s" . persp-switch)
	      ("f" . persp-frame-switch)
	      )

  :config
  ;; (global-set-key (kbd "C-c TAB") persp-key-map)
  (setq wg-morph-on nil) ;; switch off animation
  (setq persp-autokill-buffer-on-remove 'kill-weak)

  ;; negative to disable auto resume
  (setq persp-auto-resume-time (if my/auto-restore-workspace
				   1.0
				 -1.0))
  ;; (setq persp-save-dir (expand-file-name "workspaces/" my/etc-dir))

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
		    (string-match-p "\\.bin\\|\\.so\\|\\.dll\\|\\.exe\\'" bname)))))


  ;; tweak to persp-mode and consult
  (with-eval-after-load 'consult
    ;; (consult-customize consult--source-buffer :hidden t :default nil)
    (defun my/persp-get-buffer-names ()
      "get persp-mode workspace buffer name list, a list of string"
      (interactive)
      ;; (mapcar #'buffer-name (persp-buffer-list-restricted))
      (let* ((persp-buffs (mapcar #'buffer-name (persp-buffer-list-restricted)))
             (all-buffs (mapcar #'buffer-name (buffer-list)))
             (this-buff (buffer-name (current-buffer)))
             (uses nil))
        (mapcar #'(lambda (buff) (if (and (member buff persp-buffs)
                                          ;; drop special buffers
                                          (string-match "^[^[:space:]*]" buff))
                                     (add-to-list 'uses buff t))) all-buffs)
        (when (equal this-buff (car uses))
          (setq uses (cdr uses)))
        uses))

    (defvar consult--source-persp-mode
      (list :name "Persp"
	    :narrow ?s
	    :category 'buffer
	    :state #'consult--buffer-state
	    :face 'consult-buffer
	    :history 'buffer-name-history
	    :default t
	    :sort t
	    :items #'my/persp-get-buffer-names))
    (add-to-list 'consult-buffer-sources 'consult--source-persp-mode))
  )


;; integration with project.el-------------------------------------------------
(defun my/posframe-buffer-p (buffer)
  "posframe 的缓冲区"
    (when-let ((buffer (get-buffer buffer)))
      (buffer-local-value 'posframe--frame buffer)))

(defun my/not-display-buffer-p (buffer)
  (let ((buffer-name (if (bufferp buffer)
	     (buffer-name buffer)
	   buffer
	   )))
    (or (member buffer-name '(" *pyim-page--posframe-buffer*" " *acm-buffer*"))
	(my/posframe-buffer-p buffer-name))
    )
)

(defun my/persp-mode-project-bridge-fix-fn ()
  (interactive)
  (mapcar (lambda (buff-name)
	    (when (buffer-live-p (get-buffer buff-name))
	      (kill-buffer buff-name)))
	  '(" *pyim-page--posframe-buffer*" " *acm-buffer*")))

(defun my/persp-mode-project-bridge-fix-advice-fn (orig-fn &rest args)
  (my/persp-mode-project-bridge-fix-fn)
  (apply orig-fn args))

(advice-add #'make-frame-command :around #'my/persp-mode-project-bridge-fix-advice-fn)
(advice-add #'ediff :around #'my/persp-mode-project-bridge-fix-advice-fn)
(advice-add #'ediff3 :around #'my/persp-mode-project-bridge-fix-advice-fn)

(my/straight-if-use 'persp-mode-project-bridge)
(use-package persp-mode-project-bridge
  :config
  :hook
  (persp-mode-project-bridge-mode . (lambda ()
                                      (if persp-mode-project-bridge-mode
                                          (persp-mode-project-bridge-find-perspectives-for-all-buffers)
                                        (persp-mode-project-bridge-kill-perspectives))))
  (persp-mode . persp-mode-project-bridge-mode))


;; integration with project.el end ---------------------------------------------

;; ;; integration with projectile--------------------------------------------------
;; (with-eval-after-load "projectile"
;;   (with-eval-after-load "persp-mode"
;;     (defvar persp-mode-projectile-bridge-before-switch-selected-window-buffer nil)

;;     ;; (setq persp-add-buffer-on-find-file 'if-not-autopersp)

;;     (persp-def-auto-persp "projectile"
;;                           :parameters '((dont-save-to-file . t)
;;                                         (persp-mode-projectile-bridge . t))
;;                           :hooks '(projectile-before-switch-project-hook
;;                                    projectile-after-switch-project-hook
;;                                    projectile-find-file-hook
;;                                    find-file-hook)
;;                           :dyn-env '((after-switch-to-buffer-adv-suspend t))
;;                           :switch 'frame
;;                           :predicate
;;                           #'(lambda (buffer &optional state)
;;                               (if (eq 'projectile-before-switch-project-hook
;;                                       (alist-get 'hook state))
;;                                   state
;;                                 (and
;;                                  projectile-mode
;;                                  (buffer-live-p buffer)
;;                                  (buffer-file-name buffer)
;;                                  ;; (not git-commit-mode)
;;                                  (projectile-project-p)
;;                                  (or state t))))
;;                           :get-name
;;                           #'(lambda (state)
;;                               (if (eq 'projectile-before-switch-project-hook
;;                                       (alist-get 'hook state))
;;                                   state
;;                                 (push (cons 'persp-name
;;                                             (concat ""
;;                                                     (with-current-buffer (alist-get 'buffer state)
;;                                                       (projectile-project-name))))
;;                                       state)
;;                                 state))
;;                           :on-match
;;                           #'(lambda (state)
;;                               (let ((hook (alist-get 'hook state))
;;                                     (persp (alist-get 'persp state))
;;                                     (buffer (alist-get 'buffer state)))
;;                                 (cl-case hook
;;                                   (projectile-before-switch-project-hook
;;                                    (let ((win (if (minibuffer-window-active-p (selected-window))
;;                                                   (minibuffer-selected-window)
;;                                                 (selected-window))))
;;                                      (when (window-live-p win)
;;                                        (setq persp-mode-projectile-bridge-before-switch-selected-window-buffer
;;                                              (window-buffer win)))))

;;                                   (projectile-after-switch-project-hook
;;                                    (when (buffer-live-p
;;                                           persp-mode-projectile-bridge-before-switch-selected-window-buffer)
;;                                      (let ((win (selected-window)))
;;                                        (unless (eq (window-buffer win)
;;                                                    persp-mode-projectile-bridge-before-switch-selected-window-buffer)
;;                                          (set-window-buffer
;;                                           win persp-mode-projectile-bridge-before-switch-selected-window-buffer)))))

;;                                   (find-file-hook
;;                                    (setcdr (assq :switch state) nil)))
;;                                 (if (cl-case hook
;;                                       (projectile-before-switch-project-hook nil)
;;                                       (t t))
;;                                     (persp--auto-persp-default-on-match state)
;;                                   (setcdr (assq :after-match state) nil)))
;;                               state)
;;                           :after-match
;;                           #'(lambda (state)
;;                               (when (eq 'find-file-hook (alist-get 'hook state))
;;                                 (run-at-time 0.5 nil
;;                                              #'(lambda (buf persp)
;;                                                  (when (and (eq persp (get-current-persp))
;;                                                             (not (eq buf (window-buffer (selected-window)))))
;;                                                    ;; (switch-to-buffer buf)
;;                                                    (persp-add-buffer buf persp t nil)))
;;                                              (alist-get 'buffer state)
;;                                              (get-current-persp)))
;;                               (persp--auto-persp-default-after-match state)))

;;     ;; (add-hook 'persp-after-load-state-functions
;;     ;;           #'(lambda (&rest args) (persp-auto-persps-pickup-buffers)) t)
;;     ))
;; ;; --------------------------------------- pojectile integration end --------------------

(provide 'init-persp-mode)
