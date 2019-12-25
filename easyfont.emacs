;; -*- coding: utf-8-unix; -*-
(setq my-font-size-en 20
      my-font-size-cn 20)
(set-face-attribute
 'default nil
 :font (font-spec :name "-DAMA-Ubuntu Mono-normal-italic-normal-*-*-*-*-*-m-0-iso10646-1"
                  :weight 'normal
                  :slant 'normal
                  :size my-font-size-en))
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font
   (frame-parameter nil 'font)
   charset
   (font-spec :name "-MS  -Microsoft YaHei-normal-normal-normal-*-*-*-*-*-*-0-iso10646-1"
              :weight 'normal
              :slant 'normal
              :size my-font-size-cn)))
