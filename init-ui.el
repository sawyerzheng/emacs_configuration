(provide 'init-ui)


(my/straight-if-use 'nerd-icons)
(use-package nerd-icons
  :commands (nerd-icons-install-fonts))

(my/straight-if-use 'nerd-icons-completion)
(use-package nerd-icons-completion
  :hook ()
  :config
  (nerd-icons-completion-mode))

(my/straight-if-use 'nerd-icons-ibuffer)
(use-package nerd-icons-ibuffer
  :straight (:type git :host github :repo "seagle0128/nerd-icons-ibuffer")
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package breadcrumb
  :straight (:type git :host github :repo "joaotavora/breadcrumb")
  :commands (breadcrumb-mode breadcrumb-local-mode)
  :config
  (setq breadcrumb-imenu-max-length 100)
  :hook (breadcrumb-local-mode . (lambda ()
                                   (setq header-line-format '(:eval (breadcrumb-imenu-crumbs)))))
  :hook ((rust-mode
          rust-ts-mode
          python-mode
          python-ts-mode
          c-mode
          c-ts-mode
          c++-mode
          c++-ts-mode
          emacs-lisp-mode
          emacs-lisp-ts-mode
          java-mode
          java-ts-mode) . breadcrumb-local-mode))

(use-package yascroll
  :straight t
  :commands (yascroll-bar-mode
             global-yascroll-bar-mode))

(use-package anzu
  :straight t
  :hook (my/startup . global-anzu-mode))

(use-package awesome-tray
  :straight (:type git :host github :repo "manateelazycat/awesome-tray")
  :commands (awesome-tray-mode)
  :config
  )

(use-package hydra-posframe
  :straight (:type git :host github :repo "Ladicle/hydra-posframe")
  :commands (hydra-posframe-mode)
  :config)


;; (use-package common-header-mode-line
;;   :straight (:type git :host github :repo "Bad-ptr/common-header-mode-line.el")
;;   :config)

(use-package holo-layer
  :straight (:type git :host github :repo "manateelazycat/holo-layer" :files ("*"))
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
