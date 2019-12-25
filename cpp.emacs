;; -*- coding: utf-8-unix; -*-
;;(load-file "~/.conf.d/ggtags.emacs")
;;(load-file "~/.conf.d/helm-gtags.emacs")
(use-package cmake-mode
  :ensure t)
(use-package cmake-ide
  :ensure t)
(use-package company-c-headers
  :ensure t)

;;=========== boost.python ==========
;; jam files
;; in folder .extra.d
(load-file "~/.conf.d/jam-mode.emacs")
;;=========== cmake-ide ==============
(cmake-ide-setup)
(load-file "~/.conf.d/cmake.emacs")

;; for c and c++ mode
(if (eq system-type 'gnu/linux)
    (progn
      (load-file "~/.conf.d/rtags.emacs")
      (load-file "~/.conf.d/irony.emacs")))
(add-hook 'c-mode-hook 
      (lambda ()
        (setq semanticdb-default-save-directory "~/.emacs.d/semanticdb")    
        (semantic-load-enable-code-helpers)
        (setq company-idle-delay t)
        (company-mode)))

;; ========== set c format style =====
(defun my/c-set-style ()
  "set c and cpp code format style"
  (c-set-style "awk"))

(add-hook 'c-mode-hook
	  'my/c-set-style)

;;=========== for company mode
(setq company-backends (delete 'company-semantic company-backends))
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)
;; ;; company-c-headers package
(add-to-list 'company-backends 'company-c-headers)
;; (add-to-list 'company-c-headers-path-system "/usr/include/c++/7/")


(defun my-c++-mode-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; (add-hook 'c-mode-hook '(lambda ()
;; 						  "indentation"
;; 						  (setq default-tab-with 4)))
;; ;; (setq c-default-style "linux"
;; ;;       c-basic-offset 4)

;; (setq-default c-basic-offset 4
;; 	      tab-width 4
;; 	      indent-tabs-mode t)
