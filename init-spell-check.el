(provide 'init-spell-check)

(use-package wucuo
  :straight t
  :hook ((text-mode prog-mode) . wucuo-start)
  :config
  (setq ispell-program-name "enchant-2"))

