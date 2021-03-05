;; -*- coding: utf-8; -*-
(use-package go-mode
  :ensure t)

;;------------------- dap
;; https://medium.com/@apmattil/debug-go-golang-with-emacs-fbf840c0aa56
;; go get -v github.com/derekparker/delve/cmd/dlv
(load-file "~/.conf.d/dap.emacs")
(require 'dap-go)
(dap-go-setup)


;; ------------------ lsp and gopls
;; depend on backend gopls
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; ------------------ snippet
(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :hook (go-mode . yas-minor-mode))
(use-package go-snippets
  :ensure t)


;; ----------------- syntax checking
;; depend of backend goflymake
(load-file "~/.conf.d/goflymake.emacs")
;; light weight, only elisp
;; (load-file "~/.conf.d/flymake-go.emacs")
;; depend on backend goclangci-lint
(load-file "~/.conf.d/flycheck-goclangci-lint.emacs")

;; ------------------ error check
(use-package go-errcheck
  :ensure t)

;; ------------------ auto-complete
(use-package go-autocomplete
  :ensure t)
(require 'go-autocomplete)
(require 'auto-complete-config)


;; ------------------ eldoc
(use-package go-eldoc
  :ensure t)
;; Don't need to require, if you install by package.el
;; (require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)
;; set style
(set-face-attribute 'eldoc-highlight-function-argument nil
		    :underline t :foreground "green"
		    :weight 'bold)
