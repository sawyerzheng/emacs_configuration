;; -*- coding: utf-8-unix; -*-
;;----------- java -----------------
;; (load-file "~/.conf.d/jdee.emacs")
;; (load-file "~/.conf.d/eclim.emacs")
;; (package-refresh-contents)
;; (use-package meghanada
;;   :ensure t)
;; ;; (use-package lsp
;;   ;; :ensure t)
;; (use-package lsp-java
;;   :ensure t)
;; (use-package lsp-ui
;;   :ensure t)
;; (use-package treemacs-projectile
;;   :ensure t)
;; (use-package dap
  ;; :ensure t)

(load-file "~/.conf.d/meghanada.emacs")
(load-file "~/.conf.d/lsp-java.emacs")
;; (load-file "~/.conf.d/eglot-java.emacs")
(load-file "~/.conf.d/dap.emacs")
(load-file "~/.conf.d/treemacs.emacs")
(load-file "~/.conf.d/jdecomp.emacs")
;; (load-file "~/.conf.d/autodisass.emacs")
(load-file "~/.conf.d/groovy.emacs")
;;-------------------------------------

(define-key java-mode-map (kbd "<tab>") 'company-indent-or-complete-common)
