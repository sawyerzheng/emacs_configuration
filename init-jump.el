(provide 'init-jump)


(use-package dumb-jump
  :straight t
  :after xref
  :hook (prog-mode . my/dumb-jump-add-activate-fn)
  :functions (my/dumb-jump-add-activate-fn)
  :commands (dumb-jump-xref-activate)
  :config
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
  (defun my/dumb-jump-add-activate-fn ()
    (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)))





(use-package ace-pinyin
  :straight t
  :commands (ace-pinyin-dwim ace-pinyin-jump-word)
  :config
  (setq ace-pinyin--jump-word-timeout 1.5)
  (ace-pinyin-global-mode +1))
