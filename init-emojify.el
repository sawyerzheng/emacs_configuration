;; -*- coding: utf-8; -*-
(use-package emojify
  :straight t
  :hook (
         (after-init . global-emojify-mode)
         (python-mode . (lambda ()
                          (set (make-local-variable 'emojify-emoji-styles) '(unicode))))
         (after-init . global-emojify-mode-line-mode))
  :config
  (setq emojify-emoji-styles '(unicode)))

(provide 'init-emojify)
