;; * bootstrap with package.el
;; (condition-case nil
;;     (require 'use-package)
;;   (file-error
;;    (require 'package)
;;    (package-initialize)
;;    (package-refresh-contents)
;;    (package-install 'use-package)
;;    (require 'use-package)))
(if (< emacs-major-version 29)
(straight-use-package '(use-package :type git :repo "jwiegley/use-package" :host github))
  (require 'use-package)
  (require 'straight))
(straight-use-package '(use-package :type git :repo "jwiegley/use-package" :host github))
(add-to-list 'use-package-keywords :straight)

(setq straight-enable-use-package-integration t)
;; * like package.el's ":ensure t"  feature
;; (setq straight-use-package-by-default t)

;; package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; use-package debug
(setq use-package-verbose t)

(use-package delight
  :straight t
  :defer t)

(use-package general
  :straight t
  ;; :commands (general-describe-keybindings general-define-key)
  ;; :defer t
  )

(require 'init-hydra)


(provide 'init-use-package)
