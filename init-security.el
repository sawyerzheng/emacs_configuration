(use-package auth-source
  :defer t
  :config
  (setq auth-sources '((:source "~/.authinfo.gpg" "~/.authinfo")))
  ;; (if my/windows-p
  ;;     (setq auth-sources '((:source "~/.authinfo.gpg" "~/.authinfo")))
  ;;   (setq auth-sources '(password-store)))
  )

(use-package epa
  :init
  (setq epa-pinentry-mode 'loopback)
  :defer t)

(use-package pass
  :straight t
  :commands (pass))

(provide 'init-security)
