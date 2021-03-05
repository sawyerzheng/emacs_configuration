;; -*- coding: utf-8-unix; -*-
;;(load-file "~/.conf.d/ggtags.emacs")
;;(load-file "~/.conf.d/helm-gtags.emacs")
(load-file "~/.conf.d/cpp-base.emacs")
;;=========== file mode =============
(add-to-list 'auto-mode-alist (cons "\\.h$" #'c++-mode))

;;=========== boost.python ==========
;; jam files
;; in folder .extra.d
(load-file "~/.conf.d/jam-mode.emacs")

;;=========== cmake-ide ==============
(cmake-ide-setup)
(load-file "~/.conf.d/cmake.emacs")

;; for c and c++ mode
(if (or (eq system-type 'gnu/linux)
	(eq system-type 'darwin))
    (progn
      (load-file "~/.conf.d/rtags.emacs")
      ;; (load-file "~/.conf.d/irony.emacs")
      ))
