(package-initialize)
;;=============== emacs init files ========================
;; init files directory  ---> ~/.conf.d/
(load-file "~/.conf.d/default.emacs")
;;(load-file "~/.conf.d/cedet.emacs")
(load-file "~/.conf.d/font.emacs")
;;(load-file "~/.conf.d/coding.emacs")
;;(load-file "~/.conf.d/flyspell.emacs")
;;(load-file "~/.conf.d/tex.emacs")
;;(load-file "~/.conf.d/zeal.emacs")
;;(load-file "~/.conf.d/eshell.emacs")

;;=============== end of init files =======================

;; full frame
(toggle-frame-maximized)
;;=============== key global binding =====================
;;(global-key-binding "\C-<SPC>" 'set-mark-command)
;;(global-key-binding (kbd "<C-lwindow-f>") 'toggle-frame-maximized)

;;===========   menubar-mode    ==============================
(menu-bar-mode t)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode t)
;;==================== variables ==============================



;;==================== >> Temp Init  << ==================
;;(set-language-environment 'Chinese-GB)
;;(set-language-environment 'UTF-8)
(setq locale-coding-system 'gbk)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (silkworm)))
 '(custom-safe-themes
   (quote
    ("59e82a683db7129c0142b4b5a35dbbeaf8e01a4b81588f8c163bd255b76f4d21" "4639288d273cbd3dc880992e6032f9c817f17c4a91f00f3872009a099f5b3f84" "ec1572b17860768fb3ce0fe0148364b7bec9581f6f1a08b066e13719c882576f" "b747fb36e99bc7f497248eafd6e32b45613ee086da74d1d92a8da59d37b9a829" default)))
 '(package-selected-packages
   (quote
    (cyberpunk-2019-theme cyberpunk-theme org-beautify-theme org-ac yasnippet-snippets popup use-package pyim sqlite helm-dash better-defaults company py-autopep8 flymake flycheck anaconda-mode jedi zeal-at-point youdao-dictionary vbasense solarized-theme silkworm-theme powershell htmlize geeknote dictionary color-theme cmake-mode avk-emacs-themes auto-complete-clang auto-complete-auctex auctex)))
 '(pyim-dicts
   (quote
    ((:name "dictA" :file "~/.emacs.d/pyim/pyim-bigdict.pyim")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))
