;; -*- coding: utf-8; -*-

;; ===================== define checks =======================
;; mypy
;; ------------- python-mypy
(flycheck-define-checker python-mypy
  "Mypy syntax and type checker.  Requires mypy>=0.580.

See URL `http://mypy-lang.org/'."
  :command ("mypy"
            "--show-column-numbers"
	    "--ignore-missing-imports"
            (config-file "--config-file" flycheck-python-mypy-config)
            (option "--cache-dir" flycheck-python-mypy-cache-dir)
            source-original)
  :error-patterns
  ((error line-start (file-name) ":" line (optional ":" column)
          ": error:" (message) line-end)
   (warning line-start (file-name) ":" line (optional ":" column)
            ": warning:" (message) line-end)
   (info line-start (file-name) ":" line (optional ":" column)
         ": note:" (message) line-end))
  :modes python-mode
  ;; Ensure the file is saved, to work around
  ;; https://github.com/python/mypy/issues/4746.
  :predicate flycheck-buffer-saved-p)

;; --------------- python-pylint
(flycheck-define-checker python-pylint
  "A Python syntax and style checker using Pylint.

This syntax checker requires Pylint 1.0 or newer.

See URL `https://www.pylint.org/'."
  ;; --reports=n disables the scoring report.
  ;; Not calling pylint directly makes it easier to switch between different
  ;; Python versions; see https://github.com/flycheck/flycheck/issues/1055.
  :command ("python3"
            (eval (flycheck-python-module-args 'python-pylint "pylint"))
            "--reports=n"
            "--output-format=json"
	    ;; "--disable=relative-beyond-top-level"
            (config-file "--rcfile=" flycheck-pylintrc concat)
            ;; Need `source-inplace' for relative imports (e.g. `from .foo
            ;; import bar'), see https://github.com/flycheck/flycheck/issues/280
            source-inplace)
  :error-parser flycheck-parse-pylint
  :enabled (lambda ()
             (or (not (flycheck-python-needs-module-p 'python-pylint))
                 (flycheck-python-find-module 'python-pylint "pylint")))
  :verify (lambda (_) (flycheck-python-verify-module 'python-pylint "pylint"))
  :error-explainer (lambda (err)
                     (-when-let (id (flycheck-error-id err))
                       (apply
                        #'flycheck-call-checker-process-for-output
                        'python-pylint nil t
                        (append
                         (flycheck-python-module-args 'python-pylint "pylint")
                         (list (format "--help-msg=%s" id))))))
  :modes python-mode
  ;; :next-checkers ((warning . python-mypy))
  )  ;; ---------------------> set next checker
;; =======================================================================================

(add-to-list 'flycheck-checkers 'python-pylint t)
;; (add-to-list 'flycheck-checkers 'python-mypy t)
(defun my:enable-python-mypy ()
  (interactive)
  (add-to-list 'flycheck-checkers 'python-mypy t))

(add-hook 'python-mode-hook 'my:enable-python-mypy)

(add-hook 'python-mode-hook '(lambda ()
			       (flycheck-mode 1)
			       ;; (flycheck-disable-checker 'lsp)
			       (flycheck-select-checker 'python-pylint)
			       (setq flycheck-pylintrc (expand-file-name "~/home/configure_files/.pylintrc"))
			       ;; (flycheck-add-next-checker 'lsp 'python-mypy)
			       ;; (flycheck-add-next-checker  'python-mypy 'python-flake8)
			       ;; (flycheck-add-next-checker 'python-mypy 'python-pylint)
			       ;; (flycheck-add-next-checker 'python-mypy '(warning . python-pylint))
			       ))


(define-key python-mode-map (kbd "C-c n") 'flycheck-next-error)
(define-key python-mode-map (kbd "C-c p") 'flycheck-previous-error)
(define-key python-mode-map (kbd "C-c l") '(lambda ()
					     (interactive)
					     (flycheck-mode 1)
					     (flycheck-list-errors)
					     (pop-to-buffer "*Flycheck errors*")))

(define-key python-mode-map (kbd "C-c C-v") '(lambda ()
					     (interactive)
					     (flymake-mode 1)
					     (flymake-show-diagnostics-buffer)
					     ))

;; set variables
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq flycheck-python-flake8-executable
		  (executable-find "flake8"))
	    (setq flycheck-python-pylint-executable
		  (executable-find "pylint"))

	    (flymake-mode -1)

	    ))
