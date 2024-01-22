(use-package god-mode
  :straight t
  :commands (god-mode god-local-mode my-toggle-god-mode )
  :bind (("C-c t g" . my-toggle-god-mode)
         :map god-local-mode-map
         ("." . repeat)
         ("i" . god-local-mode))
  :config
  (global-set-key (kbd "C-x C-1") #'delete-other-windows)
  (global-set-key (kbd "C-x C-2") #'split-window-below)
  (global-set-key (kbd "C-x C-3") #'split-window-right)
  (global-set-key (kbd "C-x C-0") #'delete-window)

  (define-key god-local-mode-map (kbd "[") #'backward-paragraph)
  (define-key god-local-mode-map (kbd "]") #'forward-paragraph)

  ;; 通过 mode-line 判断 god-mode 是否开启
  (defvar my-cache-orginal-mode-line-things nil)
  (defun my-god-mode-update-mode-line ()
    (cond
     (god-local-mode
      (set-face-attribute 'mode-line nil
                          :foreground "#604000"
                          :background "#fff29a")
      (set-face-attribute 'mode-line-inactive nil
                          :foreground "#3f3000"
                          :background "#fff3da"))
     (t
      (set-face-attribute 'mode-line nil
                          :foreground "#0a0a0a"
                          :background "#d7d7d7")
      (set-face-attribute 'mode-line-inactive nil
                          :foreground "#404148"
                          :background "#efefef"))))

  ;; (add-hook 'post-command-hook 'my-god-mode-update-mode-line)
  (defvar my-god-mode-enable-p -1)
  (defun my-enable-god-mode ()
    (interactive)
    (unless god-global-mode
      (god-mode))
    (global-set-key (kbd "<escape>") #'god-local-mode))

  (defun my-disable-god-mode ()
    (interactive)
    (when god-global-mode
      (god-mode))
    (global-unset-key (kbd "<escape>")))

  (defun my-toggle-god-mode ()
    (interactive)
    (if god-global-mode
        (my-disable-god-mode)
      (my-enable-god-mode)))

  ;; 设置光标形状，在非 god-local-mode (即插入模式)的时候，光标为竖线形状（'bar）
  (defun my-god-mode-update-cursor-type ()
    (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar)))

  ;; (add-hook 'post-command-hook #'my-god-mode-update-cursor-type)

  (with-eval-after-load 'which-key
    (which-key-enable-god-mode-support))


  ;; isearch integration
  (require 'god-mode-isearch)
  ;; (define-key isearch-mode-map (kbd "<escape>") #'god-mode-isearch-activate)
  (define-key god-mode-isearch-map (kbd "<escape>") #'god-mode-isearch-disable)

  ;; repeat
  (define-key god-local-mode-map (kbd ".") #'repeat)
  )

(provide 'init-god-mode)
