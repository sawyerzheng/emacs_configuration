;; -*- coding: utf-8-unix; -*-
;; package: https://github.com/DarwinAwardWinner/ido-completing-read-plus

(use-package ido-completing-read+
  :ensure t)

;;========= ido itself
(ido-mode 1)
;; (ido-everywhere 1)

(require 'ido-completing-read+)
(ido-ubiquitous-mode 1)

;;============ Amx ============================
;; for key M-x
;; (use-package amx
;;   :ensure t)
;; (require 'amx)
;; (amx-mode 1)

;;=========== ido yes or not ====================
(use-package ido-yes-or-no
  :ensure t)
(require 'ido-yes-or-no)
(ido-yes-or-no-mode 1)

;;=========== emacs built in soft support ====================
;; magit
(setq magit-completing-read-function 'magit-ido-completing-read)
;; gnus
(setq gnus-completing-read-function 'gnus-ido-completing-read)
;; ess
(setq ess-use-ido t)

;;================ icomplete-mode ============================
;; for more places to operate functionally.
(use-package icomplete
  :ensure t)
;; (require 'icomplete)
;; (icomplete-mode 1)
