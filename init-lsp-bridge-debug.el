(setq user-emacs-directory "~/.emacs.d.clean")

(load-file "~/.conf.d/load-tools.emacs")
(load-file "~/.conf.d/straight.emacs")
(load-file "~/.conf.d/projectile.emacs")
(load-file "~/.conf.d/conda.emacs")
(load-file "~/.conf.d/corfu.emacs")
(load-file "~/.conf.d/lsp-bridge.emacs")

(provide 'init-lsp-bridge-debug)
