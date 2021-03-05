;; -*- coding: utf-8; -*-
;; (load-file "~/.conf.d/doom-modeline.emacs")
;; (if (equal system-type 'windows-nt)
;;     nil
;;  (load-file "~/.conf.d/sky-color-clock.emacs"))



(use-package nyan-mode
  :ensure t)
;; (nyan-mode 1)
(use-package mini-modeline
  :ensure t
  ;; :quelpa (mini-modeline :repo "kiennq/emacs-mini-modeline" :fetcher github)
  ;; :after smart-mode-line
  )
(setq mini-modeline nil)
