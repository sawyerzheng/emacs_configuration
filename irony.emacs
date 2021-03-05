;; -*- coding: utf-8-dos; -*-

(use-package irony
  :ensure t)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)


;; Windows performance tweaks
;;
(when (boundp 'w32-pipe-read-delay)
  (setq w32-pipe-read-delay 0))
;; ;; Set the buffer size to 64K on Windows (from the original 4K)
(when (boundp 'w32-pipe-buffer-size)
  (setq irony-server-w32-pipe-buffer-size (* 64 1024)))

;; flycheck-irony
;; -----
;; a sub package of irony
(use-package flycheck-irony
  :ensure t)
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))
;; (add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
;; eldoc for irony
(use-package irony-eldoc
  :ensure t)
(add-hook 'irony-mode-hook #'irony-eldoc)
