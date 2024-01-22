(provide 'init-auto-save)

;; (use-package real-auto-save
;;   :straight t
;;   :hook ((prog-mode markdown-mode org-mode) . real-auto-save-mode)
;;   :config
;;   (setq real-auto-save-interval 5))

(use-package auto-save
  :straight (:type git :host github :repo "manateelazycat/auto-save")
  :hook ((prog-mode markdown-mode org-mode) . auto-save-enable)
  :config
  (setq auto-save-idle 3)

  (setq auto-save-silent t)             ; quietly save
  ;; (setq auto-save-delete-trailing-whitespace t)  ; automatically delete spaces at the end of the line when saving

  ;; custom predicates if you don't want auto save.
  ;; disable auto save mode when current filetype is an gpg file.
  (setq auto-save-disable-predicates
        '((lambda ()
            (string-suffix-p
             "gpg"
             (file-name-extension (buffer-name)) t))))
  )
