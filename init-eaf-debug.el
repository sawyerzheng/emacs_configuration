;; ;; set load path
;; (add-to-list 'load-path "~/.conf.d" t)
;; (add-to-list 'load-path "~/.conf.d/extra.d/" t)
;; ;; (require 'init-benchmark-init)
;; ;; (require 'init-esup)
;; (global-unset-key (kbd "C-h r"))
;; (defun my/reload-init-file () (interactive) (load-file user-init-file))
;; (global-set-key (kbd "C-h r r") #'my/reload-init-file)

;; (require 'init-load-tools)
;; ;; (require 'init-lib-regexp)
;; ;; (require 'init-proxy)
;; (require 'init-straight)


;; (global-set-key (kbd "C-h r f") #'my-straight-make-sure-freeze-packages)

;; (unless (directory-empty-p (expand-file-name "straight/build/use-package" user-emacs-directory))
;;   (add-to-list 'load-path (expand-file-name "straight/build/use-package" user-emacs-directory) t))

;; (require 'init-use-package)
;; ;; (require 'init-no-littering)
;; ;; (require 'init-compat) ;; for compatibility
;; ;; (require 'major-mode-hydra)
;; ;; (require 'init-logging)

;; ;; (require 'init-eaf)
;; (if (eq system-type 'windows-nt)
;;     (progn (setq eaf-path-prefix "d:/programs/eaf/")
;;            (setq eaf-python-command "d:/soft/miniconda3/envs/eaf/python.exe")
;;            ;; (setq eaf-python-command "d:/programs/eaf/.venv/Scripts/python.exe")

;;            )
;;   (progn (setq eaf-path-prefix (expand-file-name "~/programs/eaf/"))
;;          ;; (setq eaf-python-command "~/miniconda3/envs/eaf/bin/python")
;;          (setq eaf-python-command (expand-file-name "~/programs/eaf/.venv/bin/python"))
;;          ))

;; (progn (setq eaf-path-prefix (expand-file-name "~/programs/eaf/"))
;;        ;; (setq eaf-python-command "~/miniconda3/envs/eaf/bin/python")
;;        (setq eaf-python-command (expand-file-name "~/programs/eaf/.venv/bin/python"))
;;        (add-to-list 'load-path eaf-path-prefix t)
;;        )
;; (add-to-list 'load-path eaf-path-prefix t)

(add-to-list 'load-path "~/.conf.d")
(require 'init-load-tools)
(require 'init-straight)
(require 'init-use-package)
(require 'init-eaf)


;; (add-subdirs-to-load-path eaf-path-prefix)
