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
  (setq emojify-display-style '(unicode))
  )

(provide 'init-emojify)
