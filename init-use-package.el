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

(use-package major-mode-hydra
  :straight t
  ;; :defer t
  :config
  (setq major-mode-hydra-invisible-quit-key (kbd "C-g"))
  )

(use-package pretty-hydra
  :straight t
  :defer t
  :commands (pretty-hydra-define pretty-hydra-define+)
  :init
  (defun icon-displayable-p ()
    "Return non-nil if icons are displayable."
    (or (display-graphic-p) (daemonp))
    (or (featurep 'all-the-icons)
        (require 'all-the-icons nil t)))

  (cl-defun pretty-hydra-title (title &optional icon-type icon-name
                                      &key face height v-adjust)
    "Add an icon in the hydra title."
    (let ((face (or face `(:foreground ,(face-background 'highlight))))
          (height (or height 1.0))
          (v-adjust (or v-adjust 0.0)))
      (concat
       (when (and (icon-displayable-p) icon-type icon-name)
         (let ((f (intern (format "all-the-icons-%s" icon-type))))
           (when (fboundp f)
             (concat
              (apply f (list icon-name :face face :height height :v-adjust v-adjust))
              " "))))
       (propertize title 'face face))))
  :config
  ;; (setq pretty-hydra--opts '(:color teal :separator :formatter :title :quit-key :width :toggle))
  )


(provide 'init-use-package)
