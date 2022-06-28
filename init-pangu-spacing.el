;; -*- coding: utf-8; -*-
;; 自动 删除 hello 中英文之间多余的空格
;; ref: https://github.com/coldnew/pangu-spacing
(use-package pangu-spacing
  :straight t
  :hook (text-mode . pangu-spacing-mode)
  :init
  (defun my-enable-pangu-insert-real-space ()
    (interactive)
    (set (make-local-variable 'pangu-spacing-real-insert-separtor) t))
  :config
  ;; (setq pangu-spacing-real-insert-separtor t)
  (add-hook 'org-mode-hook #'my-enable-pangu-insert-real-space)
  (add-hook 'markdown-mode-hook #'my-enable-pangu-insert-real-space)
  (add-hook 'gfm-mode-hook #'my-enable-pangu-insert-real-space)
  )

(provide 'init-pangu-spacing)
