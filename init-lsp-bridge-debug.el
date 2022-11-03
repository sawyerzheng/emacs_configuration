(setq user-emacs-directory "~/.emacs.d.clean")

;; (load-file "~/.conf.d/init-load-tools.el")
;; (load-file "~/.conf.d/straight.emacs")
;; (load-file "~/.conf.d/projectile.emacs")
;; (load-file "~/.conf.d/conda.emacs")
;; (load-file "~/.conf.d/corfu.emacs")
;; (load-file "~/.conf.d/lsp-bridge.emacs")
(add-to-list 'load-path "~/programs/lsp-bridge/")
(add-to-list 'load-path "d:/programs/lsp-bridge/")

(package-install 'yasnippet)
(package-install 'markdown-mode)
(package-install 'posframe)
(package-install 'dash) ;; for tabnine-bridge
(package-initialize)

(require 'dash)

(require 'yasnippet)
(yas-global-mode 1)

(require 'lsp-bridge)
(setq acm-enable-tabnine-helper t)
(global-lsp-bridge-mode)

(define-key lsp-bridge-mode-map (kbd "C-M-i") #'lsp-bridge-popup-complete)

;; (load-file "~/.conf.d/quick.emacs")

(setq lsp-bridge-python-command
      (cond ((eq system-type 'windows-nt) "d:/soft/miniconda3/envs/tools/python.exe")
            (t "/home/sawyer/miniconda3/envs/tools/bin/python")))

(provide 'init-lsp-bridge-debug)
