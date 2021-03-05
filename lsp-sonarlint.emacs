;; -*- coding: utf-8; -*-
(use-package lsp-sonarlint
  :ensure t)



(defun my:lsp-sonarlint-enable-python ()
  (require 'lsp-sonarlint-python)
  (setq lsp-sonarlint-python-enabled t))

(defun my:lsp-sonarlint-enable-java ()
  (require 'lsp-sonarlint-java)
  (setq lsp-sonarlint-java-enabled t))

(add-hook 'python-mode-hook 'my:lsp-sonarlint-enable-python)
(add-hook 'java-mode-hook 'my:lsp-sonarlint-enable-java)
