(use-package nav-flash
  :straight t
  :autoload (nav-flash-show)
  :hook ((imenu-after-jump
          better-jumper-post-jump
          xref-after-jump
          xref-after-return
          ) . nav-flash-show)
  )

(advice-add #'lsp-bridge-find-def :after #'nav-flash-show)
(advice-add #'lsp-bridge-find-impl :after #'nav-flash-show)
(advice-add #'lsp-bridge-find-impl-other-window :after #'nav-flash-show)
(advice-add #'lsp-bridge-find-def-return :after #'nav-flash-show)
;; (advice-add #'lsp-bridge-find-references :after #'nav-flash-show)

(provide 'init-nav-flash)
