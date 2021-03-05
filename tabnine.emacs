;; -*- coding: utf-8; -*-
(use-package company-tabnine :ensure t
  :config
  (add-to-list 'company-backends #'company-tabnine))

(setq company-show-numbers t)
