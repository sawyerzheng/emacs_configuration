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


(use-package pytest
  :straight t
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


(use-package python-pytest
  :straight t
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

(use-package code-cells
  :straight t
  :commands (code-cells-mode-maybe
             code-cells-mode)
  :hook (python-mode . code-cells-mode-maybe)
  :config
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

(use-package pipenv
  :straight t
  :commands (pipenv-mode
             pipenv-activate
             pipenv-deactivate))

(use-package poetry
  :straight t
  :commands (poetry-venv-workon
             poetry-venv-deactivate
             poetry-shell
             poetry-new
             poetry-run
             poetry-init
             poetry-lock
             poetry-show
             poetry-build
             poetry-check
             poetry-remove
             poetry-update
             poetry-add-dep
             poetry-publish
             poetry-add-dev-dep
             poetry-add-opt-dep
             poetry-self-update
             poetry-venv-toggle
             poetry-tracking-mode
             poetry-install-install
             poetry-edit-pyproject-toml
             ))


(defun my/venv-activate ()
  (interactive)
  (let* ((root (project-root (project-current t)))
         (local-python (cond ((file-exists-p (expand-file-name "./venv/bin/python" root))
                              (expand-file-name "./venv/" root))
                             ((file-exists-p (expand-file-name "./.venv/bin/python" root))
                              (expand-file-name "./.venv/" root))
                             ((file-exists-p (expand-file-name "./venv/Scripts/python.exe" root))
                              (expand-file-name "./venv/Scripts/python.exe" root))
                             ((file-exists-p (expand-file-name "./.venv/" root))
                              (expand-file-name "./.venv/" root))
                             (t nil))))
    (if local-python
        (pyvenv-activate local-python)
      (call-interactively #'pyvenv-activate))))
