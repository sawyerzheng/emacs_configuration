;; -*- coding: utf-8; -*-
;;====================== exec current buffer =============
(defun my-elpy/execute-buffer ()
  "Execute the buffer with python -m path.module.current.
If there is not function elpy-project-root, use xah lee's function"
  (interactive)
  (setq file (buffer-file-name))
  (setq default-directory (file-name-directory file))
  (message default-directory)
  ;; (setq root (elpy-project-root))
  (if (boundp 'elpy-project-root)
      (setq root (elpy-project-root))

    (unless (setq root (vc-root-dir))
      (setq root (projectile-project-root))))

  (if (and root file)
      (my-elpy/execute-from-project-root file root)
    (progn
      (unless root
        (if (featurep 'elpy)
            (message "Not find project root. Use elpy to set it or create file .dir-locals.el in project root.")
          (message "Not find project root. Create file .dir-locals.el in project root or use `git init' at project root.")))

      (if root
          (message "Not valid file %s" file)))))

(defun my-elpy/execute-from-project-root (file root)
  "execute current file with `python -m' command"
  ;; save file
  (when (not (buffer-file-name)) (save-buffer))
  (when (buffer-modified-p) (save-buffer))
  (save-some-buffers)
  (let* ((file (expand-file-name file))
         (root (expand-file-name root))
         (default-directory root)
         (relative-name (file-relative-name file root))
         (module-name (replace-regexp-in-string "/" "." (file-name-sans-extension relative-name)))
         (newBuffName "*Run Python*")
         (newBuff (get-buffer-create newBuffName))
         (command (format "%s -m %s " (executable-find "python") module-name)))


    ;; clear previous content
    (add-to-list 'auto-mode-alist '("*Run Python*" . compilation-mode))
    (pop-to-buffer newBuff)
    ;; (switch-to-buffer-other-window newBuff)

    (with-current-buffer newBuff
      (setq major-mode 'compilation-mode)
      (setf (buffer-string) "")

      (princ (concat "# -*- mode: compilation; command: " command " -*- " "\n\n")
             newBuff))



    ;; (setq program (concat command " " module-name))
    ;; (cd root)
    ;; (call-process "python" nil newBuff nil "-m" module-name)
    (progn
      ;; (switch-to-buffer-other-window newBuff)
      ;; (shell-command command newBuff)
      ;; (start-process-shell-command newBuffName newBuff command)
      (with-current-buffer newBuff
        (compile command)))


    (with-current-buffer newBuff
      ;; (run-mode-hooks compilation-mode-hook)
      ;; (set-buffer-major-mode newBuff)
      ;; (setq-default major-mode 'compilation-mode)
      (ignore-errors
        ;; (funcall 'compilation-mode)
        ;; (compilation-mode 1)
        ;; (normal-mode)
        (read-only-mode -1))
      (local-set-key (kbd "q") 'quit-window))

    ;; (start-process "python-run-module" newBuff "python" "-m" module-name)
    ;; (cd (file-name-directory file))
    ))


;; -*- coding: utf-8; -*-
;;====================== exec current buffer =============
(defun my-elpy/test-buffer ()
  "Execute the buffer with python -m path.module.current.
If there is elpy-project-root can't be found, use xah lee's function"
  (interactive)
  ;; (setq root (elpy-project-root))
  (setq root (projectile-project-root))
  (setq file (buffer-file-name))
  (if (and root file)
      (my-elpy/test-from-project-root file root "pytest")
    (progn
      (unless root
        (message "Not find project root, use elpy to set it"))
      (if root
          (message "Not valid file %s" file)))))


(defun my-elpy/test-from-project-root (file root test-runner)
  "Run unittest from project root given test runner eg: pytest unittest,
 with `python -m pytest' command."
  ;; save file
  (when (not (buffer-file-name)) (save-buffer))
  (when (buffer-modified-p) (save-buffer))
  (save-some-buffers)
  (let ((command)
        newBuffName
        newBuff
        output
        program)
    (setq root (expand-file-name root))
    (setq file (expand-file-name file))
    ;; (message "Error:")
    ;; (message  module-name)
    ;; (message file)
    ;; (message root)
    ;; (message relative-name)
    (format "python -m %s %s" test-runner root)
    (setq newBuffName "*Test Python*")
    (setq newBuff (get-buffer-create newBuffName))

    ;; file in the project root
    ;; (if (equal (cl-search "/" module-name) nil)
    ;;	(setq program (concat "python" " " relative-name))
    ;;   (setq program (concat command " " module-name)))

    ;; clear previous content
    (with-current-buffer newBuff
      (ignore-errors
        (compilation-mode 1)
        (read-only-mode -1))
      (local-set-key (kbd "q") 'quit-window))

    (pop-to-buffer newBuff)
    (setf (buffer-string) "")

    (setq command (format "python -m %s %s" test-runner "."))
    (princ (concat "-*- command: " command " " " -*- " "\n\n")
           newBuff)
    ;; (cd root)
    (let ((default-directory root))
      (shell-command command newBuff))
    ;; (call-process "python" nil newBuff nil "-m" test-runner root)


    ;; (cd (file-name-directory file))
    ))

;; (define-key elpy-mode-map (kbd "C-c r") 'my-elpy/execute-buffer)
(use-package python
  :commands (python-mode)
  :bind (:map python-mode-map
              ("C-c l r r" . my-elpy/execute-buffer)))

;; (defun my-python/bind-test ()
;;   (local-set-key (kbd "C-c r") 'my-elpy/execute-buffer)
;;   (if (boundp 'elpy-test)
;;       (local-set-key (kbd "C-c t") 'elpy-test)
;;     (local-set-key (kbd "C-c t") 'my-elpy/test-buffer))
;;   )

;; (add-hook 'python-mode-hook 'my-python/bind-test)


;;========================================================


;; ============= virtualenv

;; (if (eq system-type 'gnu/linux)
;;     (setq python-my-virtualenv-prefix "/home/sawyer/miniconda3/envs"))

;; (if  (eq system-type 'windows-nt)
;;     ;; (setq python-my-virtualenv-prefix "d:/soft/miniconda3/envs")
;;     (setq python-my-virtualenv-prefix "d:/soft/miniconda3/envs")
;;   )
;; (pyvenv-activate (concat python-my-virtualenv-prefix "/py37"))

;; (defun myactivate ()
;;   (interactive)
;;   (let ((select-env "base")
;; 		(condidates nil))

;; 	(setq condidates (mapcar (lambda (env) (if (not (string-prefix-p "." env)) env))
;; 							 (directory-files (concat python-my-virtualenv-prefix "/"))
;; 							 ))
;; 	(setq condicates (remove-duplicates condidates :test 'eq))
;; 	(setq condidates (remove nil condidates))
;; 	(message "available envs: %s" condidates)
;; 	(if (equal (length condidates) 1)
;; 		(progn
;; 		  (message "Just base env, no others!")
;; 		  (setq select-env "base"))
;; 	  (setq select-env (ido-completing-read "Choose conda env:" condidates)))
;; 	;; (print select-env)
;; 	(pyvenv-activate (concat python-my-virtualenv-prefix "/" select-env))
;; 	)
;;   )



;;========= use ipython fully
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")



;; ;; ========== customize for  file or directory local variables ============
;; ;; ref: https://stackoverflow.com/questions/5147060/how-can-i-access-directory-local-variables-in-my-major-mode-hooks
;; (defun run-local-vars-mode-hook ()
;;   "Run a hook for the major-mode after the local variables have been processed."
;;   (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

;; (add-hook 'hack-local-variables-hook 'run-local-vars-mode-hook)
;; ;; (add-hook 'python-mode-local-vars-hook 'Our-self-defined-function)
;; ;;=========================================================================

;; (defun python-my-activate-project-env ()
;;   (interactive)
;;     (if (and (boundp 'python-my-project-env) python-my-project-env)
;; 	(pyvenv-activate (concat python-my-virtualenv-prefix  "/" python-my-project-env)))
;;     )
;; (add-hook 'python-mode-local-vars-hook 'python-my-activate-project-env)

;; (defvar my:project-conda-env nil
;;   "project level conda env")

;; (defun my:project-activate-conda-env ()
;;   (interactive)
;;   (unless (eq my:project-conda-env nil)
	
;; 	(pyvenv-activate (concat python-my-virtualenv-prefix "/" my:project-conda-env)))
;;   (message "enabled %s" my:project-conda-env)
;;   )

;; (add-hook 'python-mode-local-vars-hook #'my:project-activate-conda-env)

(provide 'init-python-basic)
