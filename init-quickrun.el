(provide 'init-quickrun)

(use-package quickrun
  :straight t
  :defer t

  :mode-hydra
  (cc-mode
   ("Run"
    (("r r" quickrun "quick run"))))
  :mode-hydra
  (c++-mode
   ("Run"
    (("r r" quickrun "quick run"))))
  )
