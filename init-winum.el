;; -*- coding: utf-8; -*-
(use-package winum
  ;; :ensure t
  ;; :defer 3
  :straight t
  :commands winum-mode
  :init
  (setq winum-keymap
	(let ((map (make-sparse-keymap)))
	  ;; (define-key map (kbd "C-`") 'winum-select-window-by-number)
	  ;; (define-key map (kbd "C-²") 'winum-select-window-by-number)
	  (define-key map (kbd "M-0") 'winum-select-window-0-or-10)
	  (define-key map (kbd "M-1") 'winum-select-window-1)
	  (define-key map (kbd "M-2") 'winum-select-window-2)
	  (define-key map (kbd "M-3") 'winum-select-window-3)
	  (define-key map (kbd "M-4") 'winum-select-window-4)
	  (define-key map (kbd "M-5") 'winum-select-window-5)
	  (define-key map (kbd "M-6") 'winum-select-window-6)
	  (define-key map (kbd "M-7") 'winum-select-window-7)
	  (define-key map (kbd "M-8") 'winum-select-window-8)
	  map))
  :hook (after-init . winum-mode)
  :config
  ;; (require 'winum)
  ;; (winum-mode)

  ;; (defun my:global_set_key (key command)
  ;; 	"unset key and bind new command, key is string"
  ;; 	(global-unset-key (kbd key))
  ;; 	(global-set-key (kbd key) command)
  ;; 	)

  ;; (my:global_set_key "M-1" 'winum-select-window-1)
  ;; (my:global_set_key "M-2" 'winum-select-window-2)
  ;; (my:global_set_key "M-3" 'winum-select-window-3)
  ;; (my:global_set_key "M-4" 'winum-select-window-4)
  ;; (my:global_set_key "M-5" 'winum-select-window-5)
  ;; (my:global_set_key "M-6" 'winum-select-window-6)
  ;; (my:global_set_key "M-7" 'winum-select-window-7)
  ;; (my:global_set_key "M-8" 'winum-select-window-8)
  ;; (my:global_set_key "M-9" 'winum-select-window-9)
  )

(provide 'init-winum)
