;; -*- coding: utf-8; -*-
;; source: https://github.com/robert-zaremba/flymake-go
(use-package flymake-go
  :ensure t)

(eval-after-load "go-mode"
  '(require 'flymake-go))
