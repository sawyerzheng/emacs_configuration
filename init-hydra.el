(my/straight-if-use 'major-mode-hydra)
(use-package major-mode-hydra
  ;; :defer t
  :config
  (setq major-mode-hydra-invisible-quit-key (kbd "C-g"))
  )

(my/straight-if-use 'pretty-hydra)
(use-package pretty-hydra
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


(provide 'init-hydra)
