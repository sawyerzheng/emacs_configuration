(package-initialize)
;;=============== emacs init files ========================
;; init files directory  ---> ~/.conf.d/
(load-file "~/.conf.d/default.emacs")
;;(load-file "~/.conf.d/cedet.emacs")
;;(load-file "~/.conf.d/font.emacs")
;;(load-file "~/.conf.d/coding.emacs")
(load-file "~/.conf.d/flyspell.emacs")
;;(load-file "~/.conf.d/tex.emacs")
;;(load-file "~/.conf.d/zeal.emacs")
(load-file "~/.conf.d/eshell.emacs")

;;=============== end of init files =======================

;;=============== key global binding =====================
;;(global-key-binding "\C-<SPC>" 'set-mark-command)
;;(global-key-binding (kbd "<C-lwindow-f>") 'toggle-frame-maximized)

;;===========   menubar-mode    ==============================
(menu-bar-mode t)
(tool-bar-mode 0)
;;(scroll-bar-mode 0)
(column-number-mode t)
;;==================== variables ==============================



;;==================== >> Temp Init  << ==================
;;(set-language-environment 'Chinese-GB)
(set-language-environment 'UTF-8)
(setq locale-coding-system 'utf-8)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes nil)
 '(custom-safe-themes
   (quote
    ("b747fb36e99bc7f497248eafd6e32b45613ee086da74d1d92a8da59d37b9a829" default)))
 '(package-selected-packages
   (quote
    (yasnippet-snippets jedi virtualenv flycheck virtualenvwrapper company-jedi zeal-at-point youdao-dictionary vbasense solarized-theme silkworm-theme python-mode powershell htmlize geeknote elpy dictionary color-theme cmake-mode avk-emacs-themes auto-complete-clang auto-complete-auctex auctex)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
