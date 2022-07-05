(provide init-better-jumper)

(use-package xref
  :straight t)
(use-package better-jumper
  :straight t
  :bind (([remap xref-pop-marker-stack] . better-jumper-jump-backward)
         ([remap xref-go-back]          . better-jumper-jump-backward)
         ([remap xref-go-forward]       . better-jumper-jump-forward)))
