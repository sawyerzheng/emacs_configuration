;; -*- coding: utf-8; -*-
;; for package flyckeck-mypy
;; which is optional static type checker in python

(use-package flycheck-mypy
  :ensure t)
(require 'flycheck-mypy)
(add-hook 'python-mode-hook 'flycheck-mode)

(add-to-list 'flycheck-disabled-checkers 'python-flake8)
(add-to-list 'flycheck-disabled-checkers 'python-pylint)
