(add-to-list 'load-path "~/.conf.d")
(require 'init-load-tools)
(require 'init-straight)
(require 'init-use-package)

(fido-vertical-mode)
(load-theme 'tsdh-dark t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(require 'init-font)
(require 'init-logging)
(use-package recentf
  :config
  (if (file-exists-p recentf-save-file)
      (setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
    )
  (setq recentf-max-saved-items 500)
  (recentf-mode 1))



;; debug-tools
(use-package markmacro
  :straight (:type git :host github :repo "manateelazycat/markmacro")
  :config
  (global-set-key (kbd "C-M-m ;") 'markmacro-mark-words)
  (global-set-key (kbd "C-M-m '") 'markmacro-mark-lines)
  (global-set-key (kbd "C-M-m /") 'markmacro-mark-chars)
  (global-set-key (kbd "C-M-m L") 'markmacro-mark-imenus)
  (global-set-key (kbd "C-M-m <") 'markmacro-apply-all)
  (global-set-key (kbd "C-M-m >") 'markmacro-apply-all-except-first)
  (global-set-key (kbd "C-M-m M") 'markmacro-rect-set)
  (global-set-key (kbd "C-M-m D") 'markmacro-rect-delete)
  (global-set-key (kbd "C-M-m R") 'markmacro-rect-replace)
  (global-set-key (kbd "C-M-m I") 'markmacro-rect-insert)
  (global-set-key (kbd "C-M-m C") 'markmacro-rect-mark-columns)
  (global-set-key (kbd "C-M-m S") 'markmacro-rect-mark-symbols)

  )

(provide 'init-lsp-markmacro-debug)
