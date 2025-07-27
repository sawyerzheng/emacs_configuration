(use-package recentf
  :config
  (if (and (not my/doom-p) (file-exists-p recentf-save-file))
      (setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
    )

  (setq recentf-max-menu-items 10
        recentf-max-saved-items 1000
        my-recentf-exclude-items
        (list "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$" "^/tmp/" "^/ssh:"
              "\\.?ido\\.last$" "\\.revive$" "/TAGS$" "^/var/folders/.+$"
              ;; persp-mode
              "persp-auto-save"
              "autosave"

	      "bookmark-default.el"
              ".gpg\\'"         ;; gpg files
              ;; ignore private DOOM temp files
              ;; (recentf-apply-filename-handlers doom-local-dir)
              ;; tramp files
              "/sshx?:.+"
	      "/sshfs:.+"
	      "~/win/.+"
	      "/home/sawyer/win/.+"
              ))
  ;; change `recentf-exclude'
  (dolist (elt my-recentf-exclude-items)
    (add-to-list 'recentf-exclude elt))
  ;; (with-eval-after-load 'persp-mode
  ;;   (if my/doom-p
  ;;       ;; doom emacs change persp auto save file name
  ;;       (add-hook! 'doom-after-modules-config-hook
  ;;         (defun +recentf-exclude-persp-save-fname ()
  ;;           (add-to-list 'recentf-exclude persp-auto-save-fname)
  ;;           ))
  ;;     (add-to-list 'recentf-exclude persp-auto-save-fname)))

  (defun doom--recent-file-truename (file)
    (if (or (file-remote-p file nil t)
            (not (file-remote-p file)))
        (file-truename file)
      file))
  (unless my/doom-p
    (setq recentf-filename-handlers '(doom--recent-file-truename substring-no-properties abbreviate-file-name))
    (recentf-mode 1))

  ;; (run-at-time nil 300 'recentf-save-list)
  )

(provide 'init-recentf)
