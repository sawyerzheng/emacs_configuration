(provide init-better-jumper)

(my/straight-if-use 'xref)

(my/straight-if-use 'better-jumper)
(use-package better-jumper
  :bind (([remap xref-pop-marker-stack] . better-jumper-jump-backward)
         ([remap xref-go-back]          . better-jumper-jump-backward)
         ([remap xref-go-forward]       . better-jumper-jump-forward)))
