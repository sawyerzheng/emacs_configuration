;; -*- coding: utf-8-unix; -*-
;; mode for jam files
;; in folder .extra.d
(require 'jam-mode)
(add-to-list 'auto-mode-alist '("[Jj]amfile\\'" . jam-mode))
(add-to-list 'auto-mode-alist '("\\.jam\\'" . jam-mode))
