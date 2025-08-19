(add-to-list 'load-path "~/.conf.d")
(require 'init-load-tools)
(require 'init-proxy)
(defvar my/install-packages-p t
  "install packages")
(when my/install-packages-p
  (require 'package)
  (package-generate-autoloads "extra.d" my/extra.d-dir))


;; not allow root install packages
(when (string-equal "root" user-login-name)
  (setq my/install-packages-p nil))

(defvar my/install-packages
  '(meow vertico consult orderless cape embark embark-consult marginalia treesit-auto compat doom-modeline markdown-mode  acm-terminal popon flymake-bridge nerd-icons shrink-path dash s f eglot-booster projectile project-x yasnippet yasnippet-snippets auto-yasnippet))

(use-package savehist
  :init
  (savehist-mode))

(use-package recentf
  :config
  (if (file-exists-p recentf-save-file)
      (setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
    )
  (setq recentf-max-saved-items 1000)
  (add-to-list 'recentf-exclude  ".gpg\\'")
  (recentf-mode 1))

(defvar bootstrap-version)

(defun my/enable-straight ()
  (interactive)
  (let ((bootstrap-file
	 (expand-file-name
	  "straight/repos/straight.el/bootstrap.el"
	  (or (bound-and-true-p straight-base-dir)
	      user-emacs-directory)))
	(bootstrap-version 7))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
	  (url-retrieve-synchronously
	   "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	   'silent 'inhibit-cookies)
	(goto-char (point-max))
	(eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage)))

(defun my/find-package-path (package)
  "package name is a symbol"
  (expand-file-name (symbol-name package)
		    (expand-file-name "straight/build" prefix)) ;; package build prefix
  )
(unless my/doom-p
  (my/straight-if-use '(lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge" :files (:defaults "*") :build  (:not compile))))
(my/straight-if-use '(acm-terminal :type git :host github :repo "twlz0ne/acm-terminal"))
(my/straight-if-use 'popon)
(my/straight-if-use '(flymake-bridge :type git :host github :repo "liuyinz/flymake-bridge"))

(let* ((prefix   (if my/linux-p
                     "/home/sawyer/.emacs.d.raw"
                   "d:/home/.emacs.d"
                   ))
       (prefix user-emacs-directory)
       (straight-base-dir prefix)
       (packages my/install-packages)
       (installed-packages (cl-remove-if-not (lambda (p) (file-exists-p (my/find-package-path p))) packages))
       (enable-straight-p (or my/install-packages-p (< (seq-length installed-packages)
						       (seq-length packages))))
       (enable-straight-p my/install-packages-p)
       )
  (when enable-straight-p
    (my/enable-straight))

  (dolist (package packages)
    (when my/install-packages-p
      ;;(straight-use-package package)
      )
    (add-to-list 'load-path (my/find-package-path package))
    )
  (add-subdirs-to-load-path (expand-file-name "straight/build/" prefix))
  )

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




;; (require 'init-straight)
;; (require 'init-use-package)
(my/straight-if-use '(org :type built-in))

;; (use-package jupyter
;;   :straight t
;;   :config
;;   (org-babel-do-load-languages
;;    'org-babel-load-languages
;;    '((emacs-lisp . t)
;;      (julia . t)
;;      (python . t)
;;      (jupyter . t))))

(my/straight-if-use 'yasnippet)
(my/straight-if-use 'markdown-mode)
(my/straight-if-use 'posframe)
;; (require 'init-lsp-bridge)
(require 'lsp-bridge)
(global-lsp-bridge-mode)
(fido-vertical-mode)
(yas-global-mode 1)
(load-theme 'tsdh-dark t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; (require 'init-font)
;; (require 'init-logging)
;; (use-package recentf
;;   :config
;;   (if (file-exists-p recentf-save-file)
;;       (setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
;;     )
;;   (setq recentf-max-saved-items 500)
;;   (recentf-mode 1))

(provide 'init-lsp-bridge-debug)
