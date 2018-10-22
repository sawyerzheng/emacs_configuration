(package-initialize)
;;=============== emacs init files ========================
;; init files directory  ---> ~/.conf.d/
(load-file "~/.conf.d/default.emacs")
(load-file "~/.conf.d/tex.emacs")
;;(load-file "~/.conf.d/cedet.emacs")
;;(load-file "~/.conf.d/font.emacs")
;;(load-file "~/.conf.d/coding.emacs")
(load-file "~/.conf.d/flyspell.emacs")
(load-file "~/.conf.d/eshell.emacs")
;;=============== end of init files =======================

;; ============== testing
;;(load "preview-latex.el" nil t t)

;; ============= Customizing for MacOS ===================
;; maximized Starup
;;(toggle-frame-maximized )
;; for Fonts
(custom-set-faces
 '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 180 :width normal)))))
;;  key binding
;; binding Control-Super-f to fullscreen
(global-set-key (kbd "<C-s-268632070>") 'toggle-frame-fullscreen)

;; set frame size
(add-to-list 'default-frame-alist '(width  . 85))
(add-to-list 'default-frame-alist '(height . 43))


;;=============== key global binding =====================
;;(global-key-binding "\C-<SPC>" 'set-mark-command)

;; ============== my defined Functions ===================
(defun shell-coding ()
  "for macOS, to display coding correctly,
with utf-8, utf-8"
  ;;  (set-buffer-process-coding-system 'utf-8 'utf-8)
  ;;  (setq locale-coding-system 'utf-8)
  ;;(setq-local current-language-environment 'English)
  )
;; add to shell mode
(add-hook 'shell-mode 'shell-coding t t)

;;===========   menubar-mode    ==============================
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode t)
;;==================== variables ==============================



;;==================== >> Temp Init  << ==================
;; For 汉语乱码，解决方案
;; 会导致eshell，shell 不识别一些字符
;(set-language-environment 'Chinese-GB)
;(setq locale-coding-system 'utf-8)
;(setq default-process-coding-system 'utf-8)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (silkworm)))
 '(custom-safe-themes
   (quote
    ("5a17bc57f77719cf3bf1d260c88364d87e4632cc506c1c9a5998a684cca1fa07" "b747fb36e99bc7f497248eafd6e32b45613ee086da74d1d92a8da59d37b9a829" default)))
 '(package-selected-packages
   (quote
    (vbasense auto-complete-auctex auctex youdao-dictionary solarized-theme silkworm-theme powershell htmlize geeknote dictionary color-theme avk-emacs-themes auto-complete-clang)))
 '(tool-bar-mode nil))
;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
; '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 130 :width normal)))))
