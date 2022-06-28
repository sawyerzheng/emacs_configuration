(use-package xah-fly-keys
  :straight (xah-fly-keys :type git :host github :repo "xahlee/xah-fly-keys")
  ;; :after (consult)
  :init
  (setq xah-fly-use-control-key nil)
  (setq xah-fly-use-meta-key nil)
  :commands (xah-fly-keys)
  :hook (after-init . xah-fly-keys)
  ;; :hook (after-init . (lambda () (require 'xah-fly-keys) (xah-fly-keys +1)))
  :bind (:map xah-fly-command-map
              ([remap recentf-open-files] . consult-recent-file))
  :config
  (xah-fly-keys-set-layout "qwerty")
  (global-set-key (kbd "<escape>") 'xah-fly-mode-toggle)
  (global-set-key (kbd "<f7>") 'xah-fly-mode-toggle)
  (defun my/activate-xah-fly-command-mode ()
    (interactive)
    (if (null xah-fly-keys)
        (xah-fly-command-mode-activate)))
  ;; (define-key xah-fly-insert-map    (kbd "M-f") 'my/activate-xah-fly-command-mode)
  (defvar my/xah-command-activate-key "M-f"
    "key to activate xah fly command mode")
  (defun my/xah-fly-rebind-keys ()
    (local-unset-key (kbd my/xah-command-activate-key))
    (local-set-key (kbd my/xah-command-activate-key) #'xah-fly-command-mode-activate))
  ;; (add-hook 'xah-fly-insert-mode-activate-hook #'my/xah-fly-rebind-keys)
  ;; (define-key xah-fly-insert-map (kbd "M-f") 'xah-fly-command-mode-activate)
  ;; (define-key xah-fly-insert-map (kbd "\\") 'xah-fly-command-mode-activate)
  ;; (add-hook 'magit-status-mode-hook #'xah-fly-insert-mode-activate)
  )

(provide 'init-xah-fly-keys)
