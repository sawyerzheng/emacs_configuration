(provide 'init-jump)
(with-eval-after-load 'xref
  (use-package dumb-jump
    :straight t
    :commands (dumb-jump-xref-activate)
    :config
    (setq xref-show-definitions-function #'xref-show-definitions-completing-read))
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package ace-pinyin
  :straight t
  :commands (ace-pinyin-dwim ace-pinyin-jump-word)
  :config
  (ace-pinyin-global-mode +1))
