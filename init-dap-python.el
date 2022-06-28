;; -*- coding: utf-8; -*-
(require 'init-dap-mode)
(use-package dap-mode
  :ensure t
  :defer t
  :config
  (require 'dap-python)
  ;; my own map
  (defvar my:java-map (make-sparse-keymap)
	"my own keymap for java")

  (which-key-add-major-mode-key-based-replacements 'python-mode
	"M-' =" "format"
	"M-' e" "errors"
	"M-' g" "generates"
	"M-' t" "tests"
	"M-' d" "debugs"

	"M-' ==" "lsp format buffer"
	)

  (setq  my:python-map
		 (let* ((map (make-sparse-keymap)))
		   ;; format
		   (define-key map (kbd "==") '("lsp format buffer" . (lambda ()
																(interactive)
																;; (setq tab-width 4)
																(lsp-format-buffer))))
		   (define-key map (kbd "=r") 'lsp-format-region)

		   ;; errors
		   (define-key map (kbd "ee") 'lsp-treemacs-errors-list)
		   (define-key map (kbd "el") 'flycheck-list-errors)
		   (define-key map (kbd "en") 'flycheck-next-error)
		   (define-key map (kbd "ep") 'flycheck-previous-error)

		   ;; generate codes
		   ;; (define-key map (kbd "gg") 'lsp-java-generate-getters-and-setters)
		   ;; (define-key map (kbd "gs") 'lsp-java-generate-to-string)
		   ;; (define-key map (kbd "ge") 'lsp-java-generate-equals-and-hash-code)
		   ;; (define-key map (kbd "go") 'lsp-java-generate-overrides)

		   ;; (define-key map (kbd "gcf") 'lsp-java-create-field)
		   ;; (define-key map (kbd "gcl") 'lsp-java-create-local)
		   ;; (define-key map (kbd "gcp") 'lsp-java-create-parameter)
		   ;; (define-key map (kbd "gi") 'lsp-java-add-import)
		   ;; (define-key map (kbd "gmc") 'lsp-java-create-method)
		   ;; (define-key map (kbd "gmu") 'lsp-java-add-unimplemented-methods)

		   ;; dap test
		   ;; (define-key map (kbd "tm") 'dap-java-run-test-method)
		   ;; (define-key map (kbd "tc") 'dap-java-run-test-class)
		   (define-key map (kbd "ta") 'pytest-all)
		   (define-key map (kbd "tm") 'pytest-module)
		   (define-key map (kbd "tt") '("dap test method" . dap-python-debug-test-at-point))

		   (define-key map (kbd "r") '("dap run buffer" . (lambda ()
															(interactive)
															(dap-debug (dap-python--template "Python :: Run file (buffer)")))))



		   ;; dap debug
		   ;; (define-key map (kbd "dm") 'dap-java-debug-test-method)
		   ;; (define-key map (kbd "dc") 'dap-java-debug-test-class)
		   ;; (define-key map (kbd "dd") 'dap-java-debug)


		   map)
		 )

  (define-key python-mode-map (kbd "M-'") my:python-map))

(provide 'init-dap-python)
