;; ;; * load with use-package
;; (if (file-exists-p (expand-file-name "straight/build/benchmark-init/benchmark-init.el" user-emacs-directory))
;;     (progn
;;       (add-to-list 'load-path (expand-file-name "straight/build/benchmark-init" user-emacs-directory))
;;       (require 'benchmark-init)
;;       (autoload #'benchmark-init/activate "benchmark-init")
;;       (autoload #'benchmark-init/deactivate "benchmark-init")
;;       ;; (autoload #'benchmark-init/show- "benchmark-init")
;;       ;; (autoload #'benchmark-init/deactivate "benchmark-init")
;;       (benchmark-init/activate)
;;       (add-hook 'after-init-hook 'benchmark-init/deactivate)))
;; ;; to install if not available after int. and to make sure load correctly.
;; (add-hook 'after-init-hook #'(lambda () (straight-use-package 'benchmark-init)))
;; ;; (use-package benchmark-init
;; ;;   ;; :load-path (lambda () (expand-file-name "straight/repos/benchmark-init" user-emacs-directory))
;; ;;   :config
;; ;;   ;; To disable collection of benchmark data after init is done.
;; ;;   (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; ;; * load with emacs require



;; (autoload #'benchmark-init/activate "benchmark-init")
;; (autoload #'benchmark-init/deactivate "benchmark-init")
;; (autoload #'benchmark-init/show-durations-tabulated "benchmark-init")
;; (autoload #'benchmark-init/show-durations-tree "benchmark-init")
(add-to-list 'load-path "~/.conf.d/extra.d/benchmark-init-el/")
(require 'benchmark-init)
;; generate `benchmark-init-loaddefs' with `make' CLI command
(require 'benchmark-init-loaddefs)
(benchmark-init/activate)
(add-hook 'after-init-hook 'benchmark-init/deactivate)

(provide 'init-benchmark-init)
