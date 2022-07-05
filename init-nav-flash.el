(use-package nav-flash
  :straight t
  :hook ((imenu-after-jump better better-jumper-post-jump-hook ) . nav-flash-show)
  )

(provide 'init-nav-flash)
