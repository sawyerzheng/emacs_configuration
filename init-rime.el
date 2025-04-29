;; -*- coding: utf-8; -*-
(my/straight-if-use 'rime)
(use-package rime
  :init
  (when my/linux-p
    (setq rime-emacs-module-header-root "/usr/include")
    )
  :custom
  (default-input-method "rime")
  :bind
  (:map rime-mode-map
        ("C-`" . 'rime-send-keybinding))
  :bind
  ("M-j" . nil)
  :config
  ;; (setq module-file-suffix "/usr/lib/x86_64-linux-gnu/")
  ;; (if (eq system-type 'windows-nt)
  ;;     (setq rime-librime-root nil)
  ;;   (setq rime-librime-root "~/.emacs.d/librime/build"))

  ;; (setq rime-user-data-dir "~/.config/ibus/rime/")
  ;; (setq rime-user-data-dir "~/.emacs.d/rime/")

  (defun my/rime--not-meow-insert-mode-p ()
    (and (fboundp #'meow-insert-mode-p) (not (meow-insert-mode-p))))

  (add-to-list 'rime-disable-predicates #'my/rime--not-meow-insert-mode-p)
  (add-to-list 'pyim-english-input-switch-functions #'my/rime--not-meow-insert-mode-p)
  
  (setq rime-translate-keybindings
        '("C-f" "C-b" "C-n" "C-p" "C-g"
          "M-n" "M-p"
          "<left>" "<right>" "<up>" "<down>"
          "<prior>" "<next>" "<delete>"))

  (setq rime-inline-ascii-trigger 'control-l)
  (define-key rime-active-mode-map (kbd "M-j") 'rime-inline-ascii)
  (setq rime-show-candidate 'popup)
  (setq rime-cursor "˰")
  ;; (setq rime-cursor "|")

  ;; defaults
  (setq rime-translate-keybindings
        '("C-f" "C-b" "C-n" "C-p" "C-g"))

  (with-eval-after-load 'key-chord
    (defun rime--enable-key-chord-fun (orig key)
      (if (key-chord-lookup-key (vector 'key-chord key))
	  (let ((result (key-chord-input-method key)))
            (if (eq (car result) 'key-chord)
		result
              (funcall orig key)))
	(funcall orig key)))

    (advice-add 'rime-input-method :around #'rime--enable-key-chord-fun)))

(provide 'init-rime)
