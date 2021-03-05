;; -*- coding: utf-8; -*-

(if (equal system-type 'windows-nt)
    (progn
      (use-package lsp-mode :commands lsp)
      (use-package lsp-ui :commands lsp-ui-mode)
      (use-package ccls
	:hook ((c-mode c++-mode objc-mode cuda-mode) .
	       (lambda () (require 'ccls) (lsp))))
      (setq ccls-executable "d:/programs/ccls/ccls/Release/ccls.exe")

      ;; flycheck
      (setq lsp-prefer-flymake nil)
      (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
      ))

(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package ccls
  :ensure t
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
	 (lambda () (require 'ccls) (lsp))))
(setq ccls-executable "d:/programs/ccls/ccls/Release/ccls.exe")

;; flycheck
(setq lsp-prefer-flymake nil)
(setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
