;; -*- coding: utf-8-unix; -*-
;; filename: packages.emacs

(if (< (string-to-number emacs-version) 27)
    (package-initialize))

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable

   ;; milkbox.net
   ;;'("melpa" . "http://melpa.milkbox.net/packages/")

   ;; tsinghua
   ;; '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
   ;;   ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))

   ;; emacs-china.org
   ;; '(;("gnu"   . "http://elpa.emacs-china.org/gnu/")
   ;;   ("melpa" . "http://elpa.emacs-china.org/melpa/"))
   t))




(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			 ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			 ))


;;(when (>= emacs-major-version 24)
;;  (require 'package)
;;  (setq package-archives '(;("gnu"   . "http://elpa.emacs-china.org/gnu/")
;;			 ("melpa" . "http://elpa.emacs-china.org/melpa/")))
;;  )



(condition-case nil
    (require 'use-package)
  (file-error
   (require 'package)
   (package-initialize)
   (package-refresh-contents)
   (package-install 'use-package)
   (require 'use-package)))
