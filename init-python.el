(provide 'init-python)

(require 'init-python-basic)
(require 'init-conda)
(require 'init-live-py-plugin)

(use-package pytest
  :straight t
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
   (:color teal)
   ("Tests"
    (("t" my/pytest-hydra/body "pytest"))
    "Debug"
    (("d d" dap-hydra "dap-hydra"))))
  )

(use-package python
  :commands (python-mode)

  )


(use-package python-pytest
  :straight t
  :commands (
             python-pytest
             python-pytest-file
             python-pytest-file-dwim
             python-pytest-files
             python-pytest-function
             python-pytest-function-dwim
             python-pytest-last-failed
             python-pytest-repeat
             )
  :pretty-hydra
  (my/pytest-hydra
   (:color teal)
   ("pytest"
    (("t" python-pytest-function-dwim "test one")
     ("m" python-pytest-file-dwim "test one"))))
  :bind (:map python-pytest-mode-map
              ("M-n" . compilation-next-error)
              ("M-p" . compilation-previous-error))
  )
