(use-package autoinsert
  :commands (auto-insert-mode auto-insert)
  :hook (my/startup . auto-insert-mode)
  :config
  (defun my/autoinsert-yas-expand ()
    "Replace text in yasnippet template."
    (yas-minor-mode 1)
    (yas/expand-snippet (buffer-string) (point-min) (point-max)))

  (setq auto-insert-directory "~/.conf.d/custom.d/auto-insert-templates/")
  (setq auto-insert 'other)
  (setq auto-insert-query nil)
  (setq auto-insert-alist
        '(
          (("\\.py\\'" . "Python file") . ["utf-8.py" my/autoinsert-yas-expand])
          (("\\.org\\'" . "Org blog file") . ["hugo-blog.org" my/autoinsert-yas-expand])
          ))

  )

(provide 'init-file-templates)
