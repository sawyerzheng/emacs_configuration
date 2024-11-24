(use-package grip-mode
  :straight t  
  :commands (grip-mode)
  :after markdown-mode
  :bind (:map markdown-mode-command-map
              ("g" . grip-mode))
  :config
  (setq grip-preview-use-webkit nil)
  (setq grip-github-user "sawyerzheng")
  (setq grip-github-password "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")
  (load-file "~/org/private/grip-setup.el")
  ;; * to support dark theme
  ;; uv tool install git+https://github.com/joeyespo/grip
  (setq my/grip-theme "dark") ;; light or dark
  (defun grip-start-process ()
    "Render and preview with grip or mdopen."
    (unless (processp grip--process)
      (if grip-use-mdopen
          (progn
            (unless (and grip-mdopen-path (executable-find grip-mdopen-path))
              (grip-mode -1)            ; Force to disable
              (user-error "The `mdopen' is not available in PATH environment"))
            (when grip--preview-file
              (setq grip--process
                    (start-process "mdopen" "*mdopen*"
                                   grip-mdopen-path
                                   grip--preview-file))
              (message "Preview `%s' on %s" buffer-file-name (grip--preview-url))))
        (progn
          (unless (and grip-binary-path (executable-find grip-binary-path))
            (grip-mode -1)              ; Force to disable
            (user-error "The `grip' is not available in PATH environment"))
          ;; Generate random port
          (while (< grip--port 6419)
            (setq grip--port (random 65535)))
          ;; Start a new grip process
          (when grip--preview-file
            (setq grip--process
                  (start-process (format "grip-%d" grip--port)
                                 (format " *grip-%d*" grip--port)
                                 grip-binary-path
                                 (format "--api-url=%s" grip-github-api-url)
                                 (format "--user=%s" grip-github-user)
                                 (format "--pass=%s" grip-github-password)
                                 (format "--title=%s - Grip" (buffer-name))
                                 (format "--theme=%s" my/grip-theme)
                                 grip--preview-file
                                 (number-to-string grip--port)))
            (message "Preview `%s' on %s" buffer-file-name (grip--preview-url))
            (sleep-for grip-sleep-time)
            (grip--browse-url (grip--preview-url)))))))
  )

(provide 'init-grip)
