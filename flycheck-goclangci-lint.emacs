;; -*- coding: utf-8; -*-
;; source: https://github.com/weijiangan/flycheck-golangci-lint
(use-package flycheck-golangci-lint
  :ensure t
  :hook (go-mode . flycheck-golangci-lint-setup))
