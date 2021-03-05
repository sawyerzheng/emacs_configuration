;; -*- coding: utf-8-unix; -*-
(use-package cmake-mode
  :ensure t)

(add-hook 'cmake-mode-hook
	  (lambda ()
	    (company-mode 1)
	    (auto-complete-mode 1)))
(define-key cmake-mode-map  [(tab)] 'company-indent-or-complete-common)

;; eldoc for cmake
(use-package eldoc-cmake
  :ensure t
  :hook (cmake-mode . eldoc-cmake-enable))
