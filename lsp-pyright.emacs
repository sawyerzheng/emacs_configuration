;; -*- coding: utf-8; -*-
;; * python type annotations
;;   use pyright module
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp))))



(defun lsp-enable-pyright ()
  (require 'lsp-pyright))

(defun lsp-disable-pyright ()
  nil
)
