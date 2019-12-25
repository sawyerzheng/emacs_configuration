;; -*- coding: utf-8; -*-
(use-package devdocs
  :ensure t)
(global-unset-key "\C-cd")
(global-set-key "\C-cd" 'devdocs-search)
