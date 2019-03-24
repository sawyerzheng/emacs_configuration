(package-initialize)
;;=============== emacs init files ========================
;; init files directory  ---> ~/.conf.d/
(load-file "~/.conf.d/default.emacs")
;;(load-file "~/.conf.d/cedet.emacs")
;;(load-file "~/.conf.d/font.emacs")
;;(load-file "~/.conf.d/coding.emacs")
;;(load-file "~/.conf.d/flyspell.emacs")
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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Noto Mono" :foundry "GOOG" :slant normal :weight normal :height 125 :width normal)))))



;;==================== >> Temp Init  << ==================
;;(set-language-environment 'Chinese-GB)
(set-language-environment 'UTF-8) ;; language environment is used for
;; recognizing prefered file coding system 
(setq locale-coding-system 'utf-8);; used for messages

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (silkworm)))
 '(custom-safe-themes
   (quote
    ("ec1572b17860768fb3ce0fe0148364b7bec9581f6f1a08b066e13719c882576f" default)))
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (bash-completion shell-command zeal-at-point youdao-dictionary vbasense solarized-theme silkworm-theme powershell htmlize geeknote dictionary color-theme cmake-mode avk-emacs-themes auto-complete-clang auto-complete-auctex auctex)))
 '(tool-bar-mode nil))
