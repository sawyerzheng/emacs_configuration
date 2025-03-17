;; -*- coding: utf-8; -*-
(my/straight-if-use 'w3m)
(use-package w3m
  :init
  (if (eq system-type 'windows-nt)
      ;; (setq w3m-command "E:/soft/msys64/usr/bin/w3m.exe")
      (setq w3m-command "d:/soft/bin/w3m.cmd"))
  (defun my/w3m-open-external ()
    (interactive)
    (browse-url w3m-current-url)
    )
  (defun my/w3m-open-external-at-point ()
    (interactive)
    (browse-url (w3m-anchor))
    )
  :bind (("C-c l 3" . w3m))
  :config
  
  ;; (set-face-background 'w3m-tab-background "#242730")
  (set-face-background 'w3m-tab-background "#575a61")
  (set-face-foreground 'w3m-tab-background "#bbc2cf")
  (set-face-background 'w3m-tab-selected "#8d9096")
  (set-face-foreground 'w3m-tab-selected "#dddddd")
  (set-face-background 'w3m-tab-unselected "#666973")
  (set-face-foreground 'w3m-tab-unselected "#cccccc")


  ;; (add-to-list 'w3m-search-engine-alist '("ergoemacs" "https://www.google.com/search?q=today+site%3Axahlee.info" utf-8))
  (use-package w3m-search
    :commands w3m-search
    :config
    (progn
      (add-to-list 'w3m-search-engine-alist '("baidu" "https://www.baidu.com/s?wd=%s" utf-8))
      (add-to-list 'w3m-search-engine-alist '("bing" "https://www.bing.com/search?q=%s" utf-8)))))


(provide 'init-w3m)
