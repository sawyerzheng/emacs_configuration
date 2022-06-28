(use-package pdf-tools
  :init
  (my-add-extra-folder-to-load-path "pdf-tools" '("lisp"))
  :straight (pdf-tools :files (:defaults "*"))
  :commands (pdf-view-mode)
  :config
  (pdf-tools-install-noverify))

(provide 'init-pdf-tools)
