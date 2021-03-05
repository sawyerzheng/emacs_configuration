;; -*- coding: utf-8; -*-
;; use lsp and clangd for windows
(load-file "~/.conf.d/cpp-base.emacs")
;; =============== clangd =========
;; -- with lsp---------------
(require 'lsp)
(require 'lsp-clients)
;; (lsp-clients-register-clangd)
;; (add-hook 'c++-mode-hook 'lsp)

;; -- with eglot -----------------
(use-package eglot
  :ensure t)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
;; hook functoin.
;; (defun win-c-hook-funs ()
;;   (eglot)
;;   )
;; (add-hook 'c-mode-hook 'win-c-hook-funs)
;; (add-hook 'c++-mode-hook 'win-c-hook-funs)
;; (add-to-list 'company-backends 'compare-clang)


;; ----- ggtags and ctags ---
;; Can not coesist with lsp or egplot
(load-file "~/.conf.d/ggtags.emacs")
(add-hook 'c++-mode-hook
	  (lambda ()
	    (ggtags-mode -1)
	    (flymake-mode 0)
	    ))

(delete '("\\.cpp?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
(delete '("\\.h?\\'" flymake-xml-init) flymake-allowed-file-name-masks)

;; =====================  cpputils-cmake  =======================
(use-package cpputils-cmake
  :ensure t)
(add-hook 'c-mode-common-hook
	  (lambda ()
	     (if (derived-mode-p 'c-mode 'c++-mode)
		 (cppcm-reload-all)
	       )))

;; OPTIONAL, somebody reported that they can use this package with Fortran
;; (add-hook 'c90-mode-hook (lambda () (cppcm-reload-all)))
;; OPTIONAL, avoid typing full path when starting gdb
(global-set-key (kbd "C-c C-g")
 '(lambda ()(interactive) (gud-gdb (concat "gdb --fullname " (cppcm-get-exe-path-current-buffer)))))
;; OPTIONAL, some users need specify extra flags forwarded to compiler
;; (setq cppcm-extra-preprocss-flags-from-user '("-I/usr/src/linux/include" "-DNDEBUG"))


;; fallback for xref and ggtags
(defun tags-find-references ()
  (interactive)
  (call-interactively (if ggtags-mode 'ggtags-find-tag-dwim 'xref-find-definitions)))

(define-key c-mode-base-map (kbd "M-.") (function tags-find-references))
