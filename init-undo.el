(provide 'init-undo)

(use-package undo-fu
  :straight t
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  ;; :bind (("C-_" . undo-fu-only-redo)
  ;;        ("C-M-_" . undo-fu-only-redo))
  :hook (after-init . undo-fu-mode)
  :config
  ;; Increase undo history limits to reduce likelihood of data loss
  (setq undo-limit 400000               ; 400kb (default is 160kb)
        undo-strong-limit 3000000       ; 3mb   (default is 240kb)
        undo-outer-limit 48000000)      ; 48mb  (default is 24mb)

  ;; copy from doom emacs
  (define-minor-mode undo-fu-mode
    "Enables `undo-fu' for the current session."
    :keymap (let ((map (make-sparse-keymap)))
              (define-key map [remap undo] #'undo-fu-only-undo)
              (define-key map [remap redo] #'undo-fu-only-redo)
              (define-key map (kbd "C-_")     #'undo-fu-only-undo)
              (define-key map (kbd "M-_")     #'undo-fu-only-redo)
              (define-key map (kbd "C-M-_")   #'undo-fu-only-redo-all)
              (define-key map (kbd "C-x r u") #'undo-fu-session-save)
              (define-key map (kbd "C-x r U") #'undo-fu-session-recover)
              map)
    :init-value nil
    :global t)

  )

(use-package undo-fu-session
  :straight t
  :hook (undo-fu-mode . global-undo-fu-session-mode)
  :config
  ;; copy from doom emacs
  (setq undo-fu-session-incompatible-files '("\\.gpg$" "/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))

  ;; HACK Fix #4993: we've advised `make-backup-file-name-1' to produced SHA1'ed
  ;;      filenames to prevent file paths that are too long, so we force
  ;;      `undo-fu-session--make-file-name' to use it instead of its own
  ;;      home-grown overly-long-filename generator.
  ;; TODO PR this upstream; should be a universal issue
  (defun +undo-fu-make-hashed-session-file-name-a (file)
    (let ((backup-directory-alist `(("." . ,undo-fu-session-directory))))
      (concat (make-backup-file-name-1 file)
              (if undo-fu-session-compression ".gz" ".el"))))
  (advice-add #'undo-fu-session--make-file-name :override #'+undo-fu-make-hashed-session-file-name-a)


  ;; HACK Use the faster zstd to compress undo files instead of gzip
  (when (executable-find "zstd")
    (defun +undo--append-zst-extension-to-file-name-a (filename)
      :filter-return #'undo-fu-session--make-file-name
      (if undo-fu-session-compression
          (concat (file-name-sans-extension filename) ".zst")
        filename))
    (advice-add #'undo-fu-session--make-file-name :filter-return #'+undo--append-zst-extension-to-file-name-a))
  )
