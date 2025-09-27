(provide 'init-ui)

(use-package nerd-icons
  :commands (nerd-icons-install-fonts))

(use-package nerd-icons-completion
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :config
  (nerd-icons-completion-mode))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(require 'init-breadcrumb)


(use-package yascroll
  :commands (yascroll-bar-mode
             global-yascroll-bar-mode))


(use-package anzu
  :hook (my/startup . global-anzu-mode))

(use-package awesome-tray
  :commands (awesome-tray-mode)
  :config
  )

(use-package hydra-posframe
  :commands (hydra-posframe-mode)
  :config)

;; (use-package common-header-mode-line
;;   :straight (:type git :host github :repo "Bad-ptr/common-header-mode-line.el")
;;   :config)


(use-package holo-layer
  :commands (my/holo-layer-enable
             my/holo-layer-disable)
  :config
  ;; (setq holo-layer-python-command my/epc-python-command)
  (setq holo-layer-python-command eaf-python-command)
  (defun my/holo-layer-enable ()
    (interactive)
    (holo-layer-enable))
  (defun my/holo-layer-disable ()
    (interactive)
    (holo-layer-disable)))




(require 'init-theme)
(require 'init-doom-themes)
(require 'init-doom-modeline)
(require 'init-nav-flash)
(require 'init-solaire)
(require 'init-tab)
(require 'init-ansi-color)
(require 'init-emojify)
