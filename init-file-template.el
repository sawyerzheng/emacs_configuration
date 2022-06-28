
(use-package autoinsert
  :commands (auto-insert-mode auto-insert)
  :hook (after-init . auto-insert-mode)
  :config
  (use-package yatemplate
    :straight t
    :config
    (setq yatemplate-dir "~/.conf.d/custom.d/file-templates"))
  )
