(use-package recentf
  :config
  (if (file-exists-p recentf-save-file)
      (setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
    )

  (setq recentf-max-menu-items 0
        recentf-max-saved-items 1000
        recentf-exclude
        (list "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$" "^/tmp/" "^/ssh:"
              "\\.?ido\\.last$" "\\.revive$" "/TAGS$" "^/var/folders/.+$"
              ;; ignore private DOOM temp files
              ;; (recentf-apply-filename-handlers doom-local-dir)
              ))

  (add-to-list 'recentf-exclude  ".gpg\\'")

  (defun doom--recent-file-truename (file)
    (if (or (file-remote-p file nil t)
            (not (file-remote-p file)))
        (file-truename file)
      file))
  (setq recentf-filename-handlers '(doom--recent-file-truename abbreviate-file-name))
  (recentf-mode 1))

(provide 'init-recentf)
