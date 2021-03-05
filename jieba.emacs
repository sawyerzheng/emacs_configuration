;; -*- coding: utf-8; -*-
;; source: https://github.com/cireu/jieba.el
;; not work currently

(use-package jsonrpc
  :ensure t)
(add-to-list 'load-path "~/.conf.d/extra.d/jieba.el")
(require 'jieba)
(jieba-mode)

;;============ dependency ====================
;; install nodejieba with npm
;;sudo npm install -g --unsafe-perm nodejieba
;;============================================
