(use-package pdf-tools
  :init
  (my/add-extra-folder-to-load-path "pdf-tools" '("lisp"))
  :mode (("\\.pdf\\'" . pdf-view-mode)
         ("\\.PDF\\'" . pdf-view-mode))
  :straight (pdf-tools :files (:defaults "*"))
  :commands (pdf-view-mode)
  :config
  (pdf-tools-install-noverify))

(use-package pdf-continuous-scroll-mode
  :after pdf-tools
  :straight (:type git :host github :repo "dalanicolai/pdf-continuous-scroll-mode.el")
  :functions (pdf-continuous-scroll-mode)
  :commands (my-enable-pdf-cscroll-mode)
  :config
  (defun my-enable-pdf-cscroll-mode ()
    (interactive)
    (pdf-continuous-scroll-mode))
  :defer t)

(use-package image-roll
  :straight (:type git :host github :repo "dalanicolai/image-roll.el")
  :defer t)

(provide 'init-pdf-tools)
