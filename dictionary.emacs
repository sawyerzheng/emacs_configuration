
;;=================== global key biding ====================
(global-set-key "\C-c\C-d" 'dictionary-search)
(global-set-key "\C-c\C-s" 'youdao-dictionary-search-at-point+)


;;===================== outline ---> foldout ===============
(eval-after-load "outline" '(require 'foldout))

;;===================== dictionary  package ================
(setq dictionary-server "localhost")

