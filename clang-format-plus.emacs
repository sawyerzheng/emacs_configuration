;; -*- coding: utf-8; -*-
(use-package clang-format+
  :ensure t)


;; (add-hook 'c-mode-hook #'clang-format+-mode)
;; (add-hook 'c++-mode-hook #'clang-format+-mode)

;; (setq clang-format-style "llvm")
(setq clang-format-style "awk")
;; for project .dir-local
;; ((c++-mode . ((mode . clang-format+))))
