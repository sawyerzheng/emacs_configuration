;; (setq user-emacs-directory "~/.emacs.d.clean")

;; (load-file "~/.conf.d/init-load-tools.el")
;; (load-file "~/.conf.d/straight.emacs")
;; (load-file "~/.conf.d/projectile.emacs")
;; (load-file "~/.conf.d/conda.emacs")
;; (load-file "~/.conf.d/corfu.emacs")
;; (load-file "~/.conf.d/lsp-bridge.emacs")
;; (add-to-list 'load-path "~/programs/lsp-bridge/")
;; (add-to-list 'load-path "d:/programs/lsp-bridge/")

;; (package-install 'yasnippet)
;; (package-install 'markdown-mode)
;; (package-install 'posframe)
;; (package-install 'dash) ;; for tabnine-bridge
;; (package-initialize)

;; (require 'dash)

;; (require 'yasnippet)
;; (yas-global-mode 1)

;; (require 'lsp-bridge)
;; (setq acm-enable-tabnine-helper t)
;; (global-lsp-bridge-mode)

;; (define-key lsp-bridge-mode-map (kbd "C-M-i") #'lsp-bridge-popup-complete)

;; ;; (load-file "~/.conf.d/quick.emacs")

;; (setq lsp-bridge-python-command
;;       (cond ((eq system-type 'windows-nt) "d:/soft/miniconda3/envs/tools/python.exe")
;;             (t "/home/sawyer/miniconda3/envs/tools/bin/python")))


(add-to-list 'load-path "~/.conf.d")
(require 'init-load-tools)
(require 'init-proxy)
(require 'init-straight)
(require 'init-use-package)
(use-package org
  :straight (:type built-in)
  )
(use-package jupyter
  :straight t
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (julia . t)
     (python . t)
     (jupyter . t))))
(use-package yasnippet
  :straight t)
(use-package markdown-mode
  :straight t)
(use-package posframe
  :straight t)
(require 'init-lsp-bridge)
(require 'lsp-bridge)
(global-lsp-bridge-mode)
(fido-vertical-mode)
(yas-global-mode 1)
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

(provide 'init-lsp-bridge-debug)
