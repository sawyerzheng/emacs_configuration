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
(menu-bar-mode 0)
(tool-bar-mode 0)
;;(scroll-bar-mode 0)
(column-number-mode t)
;;==================== variables ==============================



;;==================== >> Temp Init  << ==================
;;(set-language-environment 'Chinese-GB)
(set-language-environment 'UTF-8)
(setq locale-coding-system 'utf-8)
