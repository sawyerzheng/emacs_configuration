;; -*- coding: utf-8; -*-
;; pip install grip
(use-package grip-mode
  :ensure t
  ;; :hook ((markdown-mode org-mode) . grip-mode)
  :hook ((markdown-mode) . grip-mode)
  :config
  (setq grip-github-user "sawyerzheng")
  (setq grip-github-password "c345de1486b26f048dee68bbd541b0bc86ef286a"))
