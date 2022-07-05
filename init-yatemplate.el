(use-package autoinsert
  :hook (after-init . (lambda () (auto-insert-mode 1)))
  :config
  (use-package yatemplate
    :straight t)
  (require 'yatemplate)
  (setq yatemplate-dir "~/.conf.d/custom.d/file-templates/")
  (yatemplate-fill-alist)
  ;; (setq auto-insert t)
  )

(provide 'init-yatemplate)
