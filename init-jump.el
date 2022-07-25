(provide 'init-jump)

(use-package dumb-jump
  :straight t
  :after xref
  :commands (dumb-jump-xref-activate)
  :defer t
  :config
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read))

(with-eval-after-load 'xref
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package ace-pinyin
  :straight t
  :commands (ace-pinyin-dwim ace-pinyin-jump-word)
  :config
  (setq ace-pinyin--jump-word-timeout 1.5)
  (ace-pinyin-global-mode +1))
