(provide 'init-python)

(require 'init-python-basic)
(require 'init-conda)
(require 'init-live-py-plugin)

(use-package python
  :init
  (defun my/python-init-settings ()
    (interactive)
    (setq-local tab-width 4))
  :hook ((python-base-mode . my/python-init-settings)))


;;; venv
(my/straight-if-use 'pyvenv)
(use-package pyvenv
  :commands (pyvenv-activate
	     pyvenv-workon
	     pyvenv-create
	     pyvenv-deactivate
	     pyvenv-restart-python
	     my/pdm-activate)
  :config
  (defun my/pdm-activate ()
    "choose venv for current project, then activate it"
    (interactive)
    (let* ((s (shell-command-to-string "pdm venv list"))
	   (lines (split-string s "\n"))
	   (pattern "^[-\\*][ \t]+\\([[:alnum:]_-]+\\):[ \t]*\\(.+\\)$")
	   (results nil)
	   selected-venv
	   selected-path)
      (dolist (line lines)
	(when (and (not (string-empty-p line))
		   (string-match pattern line))
	  (push (list :name (match-string 1 line)
                      :path (match-string 2 line))
		results)))
      (setq results (nreverse results))
      (setq results (mapcar (lambda (item)
                              (cons (plist-get item :name)
				    (plist-get item :path)))
			    results))


      (if (length= results 1)
	  (setq selected-venv (car (car results)))
	(setq selected-venv (completing-read "Choose pdm venv:" (mapcar 'car results))))
      
      (setq selected-path (cdr (assoc selected-venv results)))
      (message "activating pdm venv: %s: %s" selected-venv selected-path)
      (pyvenv-activate selected-path)
      (message "activated pdm venv: %s: %s" selected-venv selected-path))

    )
  )



;;; python unittest
(my/straight-if-use 'pytest)
(use-package pytest
  :commands (pytest-one
             pytest-all
             pytest-pdb-one)
  :config
  ;; fix max-specpdl-size error, ref: https://github.com/ionrock/pytest-el/issues/31#issuecomment-744414915
  (defun pytest-cmd-format (&rest _) (concat "pytest " (my/get-project-root)))
  (defun pytest-find-test-runner () nil)
  :pretty-hydra
  (my/pytest-hydra
   ("pytest"

    (("o" pytest-one "test one")
     ("a" pytest-all "test all")
     ;; ("m" pytest-module "test module")
     ("d" pytest-pdb-one "pdb one"))))

  :mode-hydra
  (python-mode
   ;; (:title "python Mode" :color blue :quit-key "q")
   (:color teal)
   ("Tests"
    (("t" my/pytest-hydra/body "pytest"))
    "Debug"
    (("d d" dap-hydra "dap-hydra"))
    "Run"
    (("r" my-elpy/execute-buffer "execute buffer")
     ("b" my/python-execute-under-cursor "execute buffer")))))

(major-mode-hydra-define+ python-base-mode
  (:title "Python Mode" :color blue :quit-key "q")
  ("Tests"
   (("t" my/pytest-hydra/body "pytest")
    )
   "Debug"
   (("d d" dap-hydra "dap-hydra"))
   "Run"
   (("r" my-elpy/execute-buffer "execute buffer")
    ("b" my/python-execute-under-cursor "execute buffer"))))


(my/straight-if-use 'python-pytest)
(use-package python-pytest
  :commands (
             python-pytest
             python-pytest-file
             python-pytest-file-dwim
             python-pytest-files

             python-pytest-run-def-or-class-at-point
             python-pytest-last-failed
             python-pytest-repeat
             )
  :pretty-hydra
  (my/pytest-hydra
   (:color teal)
   ("pytest"
    (("t" python-pytest-run-def-or-class-at-point "test one")
     ("f" python-pytest-file "test file")
     ("d" python-pytest-dispatch))))
  :bind (:map python-pytest-mode-map
              ("M-n" . compilation-next-error)
              ("M-p" . compilation-previous-error))
  )

;;; Code Cells
(my/straight-if-use 'code-cells)
(use-package code-cells
  :commands (code-cells-mode-maybe
             code-cells-mode)
  :hook (python-mode . code-cells-mode-maybe)
  :config
  (defun my/code-cells-ipynb-to-py:percent ()
    (interactive)
    (shell-command  (format "jupytext --to py:percent %s" (completing-read "select jupyter file: " (split-string (shell-command-to-string "ls -a *.ipynb"))))))

  (defun my/code-cells-ipynb-to-md ()
    (interactive)
    (shell-command  (format "jupytext --to md %s" (completing-read "select jupyter file: " (split-string (shell-command-to-string "ls -a *.ipynb"))))))

  (defun code-cells-my-insert-ahead ()
    (interactive)
    (let* ((place (code-cells--bounds))
           (start (car place))
           (end (nth 1 place)))
      (goto-char start)
      (newline)
      (previous-line)
      (insert comment-start "%%\n")))
  (defun code-cells-my-insert-after ()
    (interactive)
    (let* ((place (code-cells--bounds))
           (start (car place))
           (end (nth 1 place)))
      (goto-char end)
      (newline)
      (previous-line)
      (insert comment-start "%%\n")))

  (defun my/code-cells-eval-forward-cell ()
    (interactive)
    (call-interactively 'code-cells-eval)
    (call-interactively 'code-cells-forward-cell))

  (defun my/code-cells-delete-cell ()
    (interactive)
    (let* ((place (code-cells--bounds))
           (start (car place))
           (end (nth 1 place)))
      (delete-region start end)))

  ;; speed keys, eval at code cells beginning
  (with-eval-after-load 'code-cells
    (let ((map code-cells-mode-map))
      (define-key map "n" (code-cells-speed-key 'code-cells-forward-cell))
      (define-key map "p" (code-cells-speed-key 'code-cells-backward-cell))
      ;; (define-key map "e" (code-cells-speed-key 'code-cells-eval))
      (define-key map "e" (code-cells-speed-key 'my/code-cells-eval-forward-cell))
      (define-key map "a" (code-cells-speed-key 'code-cells-my-insert-ahead))
      (define-key map "b" (code-cells-speed-key 'code-cells-my-insert-after))
      (define-key map "d" (code-cells-speed-key 'my/code-cells-delete-cell))
      (define-key map (kbd "TAB") (code-cells-speed-key 'outline-cycle))))

  :bind (:map code-cells-mode-map
              ("C-c C-c" . code-cells-eval)
              ("M-<RET>" . code-cells-eval)
              ([S-return] . my/code-cells-eval-forward-cell)
              ("M-<up>" . code-cells-move-cell-up)
              ("M-<down>" . code-cells-move-cell-down)
              ("C-c C-n" . code-cells-forward-cell)
              ("C-c C-p" . code-cells-backward-cell)
              ("C-M-a" . code-cells-backward-cell)
              ("C-c C-a" . code-cells-my-insert-ahead)
              ("C-c C-b" . code-cells-my-insert-after)
              ("C-c C-d" . my/code-cells-delete-cell)
              ))


;;;###autoload
(defun my/venv-activate ()
  (interactive)
  (let* ((root (project-root (project-current t)))
         (local-python (cond ((and (string> my/conda-project-env "") (file-exists-p my/conda-project-env))
                              my/conda-project-env)
                             ((file-exists-p (expand-file-name "./venv/bin/python" root))
                              (expand-file-name "./venv/" root))
                             ((file-exists-p (expand-file-name "./.venv/bin/python" root))
                              (expand-file-name "./.venv/" root))
                             ((file-exists-p (expand-file-name "./venv/Scripts/python.exe" root))
                              (expand-file-name "./venv/Scripts/python.exe" root))
                             ((file-exists-p (expand-file-name "./.venv/" root))
                              (expand-file-name "./.venv/" root))
                             (t nil))))
    (if local-python
        (progn
          (message "activate venv: %s" local-python)
          (pyvenv-activate local-python))

      (call-interactively #'pyvenv-activate))))


;; convert python object to json
(defun my/python-object-to-json ()
  (interactive)
  (let* ((start (region-beginning))
	 (end (region-end)))
    (when (region-active-p)
      (shell-command-on-region start end "python -c 'import sys,json;print(json.dumps(eval(sys.stdin.read()),ensure_ascii=False, indent=2))'" (current-buffer) t))))

(defalias 'my/pyvenv-activate #'my/venv-activate)
