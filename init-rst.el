;; -*- coding: utf-8; -*-
;; reStructed Text mode

;; rst-mode 帮助：https://docutils.sourceforge.io/docs/user/emacs.html

(use-package xref-rst
  :straight t
  :config
  (add-hook 'rst-mode-hook
            (lambda ()
              (xref-rst-mode 1))))

(use-package auto-complete-rst
  :straight t
  :config
  (auto-complete-rst-init))


;; sphinx-mode
;; 1) a minor mode; 2) add extra feature for rst mode
;; ref: https://github.com/Fuco1/sphinx-mode
;; 调用：1) sphinx-compile (C-c C-x C-c); 2) sphinx-compile-and-view (C-c C-x C-v)
(use-package sphinx-mode
  :straight t
  :config
  (require 'sphinx-mode)
  (add-hook 'rst-mode 'sphinx-mode))

(provide 'init-rst)
