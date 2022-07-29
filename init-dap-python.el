;; -*- coding: utf-8; -*-
(require 'init-dap-mode)
(use-package dap-mode
  :ensure t
  :defer t
  :config
  (require 'dap-python)
  )

(provide 'init-dap-python)
