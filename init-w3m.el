;; -*- coding: utf-8; -*-
(use-package w3m
  :demand t
  :init
  (if (eq system-type 'windows-nt)
      ;; (setq w3m-command "E:/soft/msys64/usr/bin/w3m.exe")
      (setq w3m-command "d:/soft/bin/w3m.cmd"))
  :config
  ;; (add-to-list 'w3m-search-engine-alist '("ergoemacs" "https://www.google.com/search?q=today+site%3Axahlee.info" utf-8))
  (use-package w3m-search
    :commands w3m-search
    :config
    (progn
      (add-to-list 'w3m-search-engine-alist '("baidu" "https://www.baidu.com/s?wd=%s" utf-8))
      (add-to-list 'w3m-search-engine-alist '("bing" "https://www.bing.com/search?q=%s" utf-8)))))

(provide 'init-w3m)
