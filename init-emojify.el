;; -*- coding: utf-8; -*-
(my/straight-if-use 'emojify)
(use-package emojify
  :hook (
         (my/startup . global-emojify-mode)
         (python-mode . (lambda ()
                          (set (make-local-variable 'emojify-emoji-styles) '(unicode))))
         (my/startup . global-emojify-mode-line-mode))
  :config
  (setq emojify-emoji-styles '(unicode))
  (when (member "Segoe UI Emoji" (font-family-list))
    (set-fontset-font
     t 'symbol (font-spec :family "Segoe UI Emoji") nil 'prepend))
  )

(provide 'init-emojify)
