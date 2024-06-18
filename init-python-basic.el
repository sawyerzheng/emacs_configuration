;; -*- coding: utf-8; -*-
;;====================== exec current buffer =============
(defun my-elpy/execute-buffer ()
  "Execute the buffer with python -m path.module.current.
If there is not function elpy-project-root, use xah lee's function"
  (interactive)
  (let* ((root (my/get-project-root))
         (file (buffer-file-name))
         (default-directory (file-name-directory file)))

    (if (and root file)
        (my-elpy/execute-from-project-root file root)
      (progn
        (unless root
          (if (featurep 'elpy)
              (message "Not find project root. Use elpy to set it or create file .dir-locals.el in project root.")
            (message "Not find project root. Create file .dir-locals.el in project root or use `git init' at project root.")))

        (if root
            (message "Not valid file %s" file))))))


(defun my/get-python-path ()
  "make the `PYTHONPATH' env variable for current python project layout"
  (let* ((root (my/get-project-root))
         (this-project-root root)
         (src-folder-dir (file-exists-p (expand-file-name "src" root)))
         (has-src-folder src-folder-dir)
         (python-path-list '(".")))
    (if has-src-folder
        (add-to-list 'python-path-list src-folder-dir t)
      (add-to-list 'python-path-list root t))
    (mapconcat 'identity python-path-list path-separator)))

(defun my/python-which-module ()
  (interactive)
  (let ((file (buffer-file-name))
        (p-root (my/get-project-root))
        (file-no-init-parent (my/detect-module-root file p-root)))
    (when (and file p-root)
      (my/python-get-module-name file file-no-init-parent)))
  )

(defun my/python-get-module-name (file root)
  (let* ((file (expand-file-name file))
         (root (expand-file-name root))
         (default-directory root)
         (relative-name (file-relative-name file root))
         (module-name (replace-regexp-in-string "/" "." (file-name-sans-extension relative-name))))
    module-name))

(defun my/python-get-module-name-cmd ()
  (let* ((file (buffer-file-name))
         (root (my/get-project-root)))
    (if (and root file)
        (my/python-get-module-name file root)
      nil)))


(defun my/path--detect-file-ext (file-ext folder)
  "check if folder hash file with given `file-ext', eg: .py"
  (directory-files folder t (format "%s$" (regexp-quote file-ext))))


(defun my/detect-module-root (file project-root)
  "file the first parent folder not having a __init__.py"
  (let* ((file-ext "__init__.py")
         (project-root (expand-file-name project-root))
         (parent (expand-file-name (file-name-directory file)))
         (parent-has-init (my/path--detect-file-ext file-ext parent)))
    (message "init: %s" (my/path--detect-file-ext file-ext parent))
    (while (and (not (string-match "^\\.\\.\\|\\.$" (file-relative-name file project-root))) parent-has-init)
      (message "parent: %s" parent)


      (setq parent (file-name-parent-directory parent))
      (message "parent: %s" parent)
      (setq parent-has-init (my/path--detect-file-ext file-ext parent)))

    parent))

(defun my-elpy/execute-from-project-root (file root)
  "execute current file with `python -m' command"
  ;; save file
  ;; (when (and (not (buffer-file-name))
  ;;            (buffer-modified-p))
  ;;   (save-buffer))

  (save-some-buffers (not compilation-ask-about-save)
                     (lambda ()
                       (and (my/get-project-root)
                            buffer-file-name
                            (string-prefix-p (my/get-project-root) (file-truename buffer-file-name)))))

  (let* ((file (expand-file-name file))
         (root (expand-file-name root))
         (this-project-root root)
         (file-no-init-parent (my/detect-module-root file root))
         (file-at-src (string= (car (file-name-split (file-relative-name file root)))
                               "src"))
         (src-root (expand-file-name "src" root))
         (root (if file-at-src
                   src-root
                 root))
         (relative-name (file-relative-name file root))
         (relative-name (file-relative-name file file-no-init-parent))


         (module-name (replace-regexp-in-string "/" "." (file-name-sans-extension relative-name)))
         (proj-name (if (project-current)
                        (project-name (project-current))
                      (directory-file-name (file-relative-name root (file-name-parent-directory root)))))
         (newBuffName (format "*%s run python*" proj-name))
         (newBuff (get-buffer-create newBuffName))
         (python-path-list '("."))
         (exec-path (if (and (boundp 'my/conda-project-env)
                             (not (string-empty-p my/conda-project-env)))
                        (progn
                          (let* ((venv-dir (cond ((file-exists-p my/conda-project-env)
                                                  my/conda-project-env)
                                                 ((file-exists-p (expand-file-name my/conda-project-env my/conda-env-extra-home))
                                                  (expand-file-name my/conda-project-env my/conda-env-extra-home))
                                                 ((file-exists-p (expand-file-name my/conda-project-env conda-env-home-directory))
                                                  (expand-file-name my/conda-project-env conda-env-home-directory))
                                                 (t
                                                  "")))
                                 (venv-bin (cond (my/windows-p
                                                  (expand-file-name "Scripts" venv-dir))
                                                 (t
                                                  (expand-file-name "bin" venv-dir)))))
                            (if (and (not (string-empty-p venv-dir)) (file-exists-p venv-bin))
                                (cons venv-bin exec-path)
                              exec-path)))
                      exec-path))
         (python-executable
          "python"
          ;; (executable-find "python")
          )
         (command (if (my/file-at-project-root file root)
                      (format "%s %s"  python-executable file)
                    (format "%s -m %s "  python-executable module-name)))


         ;; (command (if (and (boundp 'my/conda-project-env)
         ;;                   (not (string-empty-p my/conda-project-env)))
         ;;              (format "conda activate %s\n%s"
         ;;                      my/conda-project-env
         ;;                      command
         ;;                      )
         ;;            command))
         ;; (command (format "cd %s\n\n%s" root command))
         )


    ;; add src path to PYTHONPATH
    (if (file-exists-p src-root)
        (add-to-list 'python-path-list src-root)
      (add-to-list 'python-path-list this-project-root))
    (with-environment-variables (("PYTHONPATH" (mapconcat 'identity python-path-list path-separator)))

      (with-current-buffer newBuff
        (setq major-mode 'compilation-mode)
        (read-only-mode -1)
        (setf (buffer-string) "")

        (princ (concat "# -*- mode: compilation; command: " command " -*- " "\n\n")
               newBuff)
        (let ((default-directory file-no-init-parent))
          (compile command))

        (ignore-errors
          (read-only-mode -1))
        (local-set-key (kbd "q") 'quit-window)))

    ))

;; (define-key elpy-mode-map (kbd "C-c r") 'my-elpy/execute-buffer)
(use-package python
  :commands (python-mode)
  :bind (:map python-mode-map
              ("C-c l r" . my-elpy/execute-buffer))
  )

(defun my/python-repl-use-ipython ()
  (interactive)
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i --simple-prompt"))

(defun my/python-repl-use-python ()
  (interactive)
  (setq python-shell-interpreter "python"
        python-shell-interpreter-args "-i"))

(setq python-shell-interpreter "python"
      python-shell-interpreter-args "-i")


(defun my/python-execute-under-cursor (&optional arg)
  (interactive "P")
  (let* ((module (my/python-which-module))
         (root (my/get-project-root))
         (file-no-init-parent (my/detect-module-root (buffer-file-name) root))
         (fun-path (which-function))
         (obj-path (concat module ":" fun-path))
         (python-command "python -c \"import sys; (m, obj) = sys.argv[1].split(':'); obj_path = obj.split('.'); import importlib; m = importlib.import_module(m); fun = getattr(m, obj_path[0]); import functools; fun = functools.reduce(lambda fun, sub_obj: getattr(fun, sub_obj), obj_path[1:], fun); print('\\n' + '='*70 + '\\n'); print('calling_function: --> ' + sys.argv[1] + '\\n\\n' + '='*70 + '\\n' ); fun()\"")
         (exec-path (if (and (boundp 'my/conda-project-env)
                             (not (string-empty-p my/conda-project-env)))
                        (progn
                          (let* ((venv-dir (cond ((file-exists-p my/conda-project-env)
                                                  my/conda-project-env)
                                                 ((file-exists-p (expand-file-name my/conda-project-env my/conda-env-extra-home))
                                                  (expand-file-name my/conda-project-env my/conda-env-extra-home))
                                                 ((file-exists-p (expand-file-name my/conda-project-env conda-env-home-directory))
                                                  (expand-file-name my/conda-project-env conda-env-home-directory))
                                                 (t
                                                  "")))
                                 (venv-bin (cond (my/windows-p
                                                  (expand-file-name "Scripts" venv-dir))
                                                 (t
                                                  (expand-file-name "bin" venv-dir)))))
                            (if (and (not (string-empty-p venv-dir)) (file-exists-p venv-bin))
                                (cons venv-bin exec-path)
                              exec-path)))
                      exec-path))
         ;; (command (format "cd %s\n" (my/get-project-root)))
         (command "")
         ;; (command (if (and (boundp 'my/conda-project-env)
         ;;                   (not (string-empty-p my/conda-project-env)))
         ;;              (format "conda activate \n%s"
         ;;                      my/conda-project-env
         ;;                      command
         ;;                      )
         ;;            command))
         (command (format "%s\n%s %s" command python-command obj-path))
         (proj-name (if (project-current)
                        (project-name (project-current))
                      (directory-file-name (file-relative-name root (file-name-parent-directory root)))))
         (newBuffName (format "*%s run python*" proj-name))
         (newBuff (get-buffer-create newBuffName)))

    (with-environment-variables (("PYTHONPATH" (my/get-python-path))
                                 ("PWD" file-no-init-parent))
      (cond
       ((and arg (which-function))
        (with-current-buffer newBuff
          (compile command)))
       (t
        (my-elpy/execute-buffer))))))

(provide 'init-python-basic)
