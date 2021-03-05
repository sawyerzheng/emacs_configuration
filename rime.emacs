;; -*- coding: utf-8; -*-
(use-package rime
  :ensure t
  :custom
  (default-input-method "rime")
  :bind
  (:map rime-mode-map
	("C-`" . 'rime-send-keybinding)))
;; (setq module-file-suffix "/usr/lib/x86_64-linux-gnu/")
(setq rime-librime-root "~/.emacs.d/librime/build")
;; (setq rime-user-data-dir "~/.config/ibus/rime/")
(setq rime-user-data-dir "~/.emacs.d/rime/")
(setq rime-show-candidate 'popup)
(setq rime-cursor "˰")
;; (setq rime-cursor "|")

;; defaults
(setq rime-translate-keybindings
      '("C-f" "C-b" "C-n" "C-p" "C-g"))
