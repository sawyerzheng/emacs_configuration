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

(use-package major-mode-hydra
  :straight t
  :demand t)

(use-package pretty-hydra
  :straight t
  :demand t
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
