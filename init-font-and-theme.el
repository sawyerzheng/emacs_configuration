(use-package doom-themes
  :straight t)

;; no save theme prop
(setq custom-safe-themes t)

(setq my-selected-theme
      (if my/graphic-p
          'doom-one
        'tsdh-dark)) ;; theme

(defun my-load-theme ()
  (interactive)
  (load-theme my-selected-theme))

(add-hook 'after-init-hook #'my-load-theme)

(provide 'init-theme)
