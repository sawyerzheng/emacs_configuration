;; -*- coding: utf-8; -*-
;; prepend clang-analyzer to clang and irony flycher
;; use shell command scan-build (clang static analyzer)

(use-package flycheck-clang-analyzer
  :ensure t
  :after flycheck
  :config (flycheck-clang-analyzer-setup))
