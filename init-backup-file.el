(use-package backup-file
  :straight (backup-file :type git :host github :repo "Andersbakken/emacs-backup-file")
  :hook (after-save . 'backup-file)
  :bind ("C-c f b" . backup-file-log)
  :config
  (setq backup-file-location (expand-file-name "git-backups/" no-littering-var-directory)))


(provide 'init-backup-file)
