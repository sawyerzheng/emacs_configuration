;; -*- coding: utf-8; -*-
(if (eq system-type 'windows-nt )
    (add-to-list 'load-path "d:/soft/msys64/mingw64/share/emacs/site-lisp/")
  (add-to-list 'load-path "~/programs/liberime"))



(require 'liberime nil t)
(with-eval-after-load "liberime"
  (liberime-select-schema "luna_pinyin_simp")
  (setq pyim-default-scheme 'rime-quanpin))

(add-hook 'after-init-hook #'liberime-sync)
