;; -*- coding: utf-8; -*-
(use-package cmake-mode
  :ensure t)
(use-package cmake-ide
  :ensure t)
(use-package company-c-headers
  :ensure t)
(use-package modern-cpp-font-lock
  :ensure t)
(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
(load-file "~/.conf.d/flycheck.emacs")

;; c++-mode files
;; ---------------------------------------------------
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;--------- irony -----
;; usable on windows
;; (load-file "~/.conf.d/irony.emacs")
;;========= flycheck =================
;; flycheck for c/c++
(load-file "~/.conf.d/flycheck-clang-tidy.emacs")
;; (add-hook 'c-mode-common-hook '(lambda ()
;;				 (flycheck-add-next-checker 'irony '(warning . c/c++-clang-tidy))
;;				 (flycheck-add-next-checker 'irony '(warning . c/c++-cppcheck))
;;				 ))


(load-file "~/.conf.d/flycheck-clang-analyzer.emacs")




(defun my/c-configure ()
	  '(lambda ()
	(setq semanticdb-default-save-directory "~/.emacs.d/semanticdb")
	;; (semantic-load-enable-code-helpers)
	(setq company-idle-delay t)
	(company-mode)
	(ggtags-mode nil)
	(my/c-set-style)))

(add-hook 'c-mode-hook 'my/c-configure)
(add-hook 'c++-mode-hook 'my/c-configure)
(add-hook 'c-mode-hook 'flycheck-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)

;; ========== set c format style =====
(load-file "~/.conf.d/clang-format-plus.emacs")

(defun my/c-set-style ()
  "set c and cpp code format style"
    ;; (setq c-default-style "awk"
	  ;; c-basic-offset 2)
    ;; (c-set-style "awk")
    )

;; the style must be set globally, not inside a hook
(setq c-default-style "awk"
      c-basic-offset 2)

(add-hook 'c-mode-hook
	  'my/c-set-style)

;;=========== for company mode
(setq company-backends (delete 'company-semantic company-backends))
(define-key c-mode-map  [(tab)] 'company-indent-or-complete-common)
(define-key c++-mode-map  [(tab)] 'company-indent-or-complete-common)
;; ;; company-c-headers package
(add-to-list 'company-backends 'company-c-headers)
;; (add-to-list 'company-c-headers-path-system "/usr/include/c++/7/")


(defun my-c++-mode-hook ()
  ;; (setq c-basic-offset 2)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'c-mode-hook 'my-c++-mode-hook)

;; (add-hook 'c-mode-hook '(lambda ()
;;						  "indentation"
;;						  (setq default-tab-with 4)))
;; ;; (setq c-default-style "linux"
;; ;;       c-basic-offset 4)

;; (setq-default c-basic-offset 4
;;	      tab-width 4
;;	      indent-tabs-mode t)


;; =============== auto c++ mode for standard head files ============
;; ----- Warning !!! ------------
;; on windows:
;; This need to set the envronment variable: INCLUDE
(require 'cl)

(defun file-in-directory-list-p (file dirlist)
  "Returns true if the file specified is contained within one of
the directories in the list. The directories must also exist."
  (let ((dirs (mapcar 'expand-file-name dirlist))
	(filedir (expand-file-name (file-name-directory file))))
    (and
     (file-directory-p filedir)
     (member-if (lambda (x) ; Check directory prefix matches
		  (string-match (substring x 0 (min(length filedir) (length x))) filedir))
		dirs))))

(defun buffer-standard-include-p ()
  "Returns true if the current buffer is contained within one of
the directories in the INCLUDE environment variable."
  (and (getenv "INCLUDE")
       (file-in-directory-list-p buffer-file-name (split-string (getenv "INCLUDE") path-separator))))

(add-to-list 'magic-fallback-mode-alist '(buffer-standard-include-p . c++-mode))
