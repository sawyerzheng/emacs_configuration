;; -*- coding: utf-8-dos; -*-
(use-package groovy-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.gradle\\'" . groovy-mode)))
