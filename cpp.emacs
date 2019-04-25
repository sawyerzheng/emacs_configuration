;; -*- coding: utf-8-unix; -*-
(load-file "~/.conf.d/ggtags.emacs")
;;(load-file "~/.conf.d/helm-gtags.emacs")



;;=========== for company mode
(setq company-backends (delete 'company-semantic company-backends))
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)
;; ;; company-c-headers package
(add-to-list 'company-backends 'company-c-headers)
(add-to-list 'company-c-headers-path-system "/usr/include/c++/7/")


