;; -*- coding: utf-8; -*-

(use-package multiple-cursors
  :straight t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package iedit
  :straight t
  :bind (("C-;" . iedit-mode)))

(provide 'init-multiple-cursors)
