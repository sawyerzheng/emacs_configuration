;; * bootstrap with package.el
;; (condition-case nil
;;     (require 'use-package)
;;   (file-error
;;    (require 'package)
;;    (package-initialize)
;;    (package-refresh-contents)
;;    (package-install 'use-package)
;;    (require 'use-package)))
(straight-use-package 'use-package)

(setq straight-enable-use-package-integration t)
;; * like package.el's ":ensure t"  feature
;; (setq straight-use-package-by-default t)

;; use-package debug
(setq use-package-verbose t)

(use-package delight
  :straight t
  :commands delight)

(use-package general
  :straight t
  :commands (general-describe-keybindings general-define-key)
  :demand t)


(provide 'init-use-package)
