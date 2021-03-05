;; -*- coding: utf-8; -*-
;; for package imenu-list imenu-anywhere
(use-package imenu-list  ;; M-x imenu-list
  :ensure t)

(use-package imenu-anywhere  ;; C-.
  :ensure t)

(use-package imenus          ;; M-x imenus,  M-s ? prefix
  :ensure t)


(global-set-key (kbd "C-.") #'ido-imenu-anywhere)
