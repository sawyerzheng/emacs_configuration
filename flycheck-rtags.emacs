;; -*- coding: utf-8; -*-
(use-package flycheck-rtags
  :ensure t)

(require 'flycheck-rtags)

;; Optional explicitly select the RTags Flycheck checker for c or c++ major mode.
;; Turn off Flycheck highlighting, use the RTags one.
;; Turn off automatic Flycheck syntax checking rtags does this manually.
(defun my-flycheck-rtags-setup ()
  "Configure flycheck-rtags for better experience."
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-check-syntax-automatically nil)
  (setq-local flycheck-highlighting-mode nil))
(add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
(add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
(add-hook 'objc-mode-hook #'my-flycheck-rtags-setup)
