(package-initialize)
;;=============== emacs init files ========================
;; init files directory  ---> ~/.conf.d/
(load-file "~/.conf.d/emacsclient.emacs")
;; (load-file "~/.conf.d/default.emacs")
;; (load-file "~/.conf.d/cedet.emacs")
;; (load-file "~/.conf.d/font.emacs")
;;(load-file "~/.conf.d/coding.emacs")
;;(load-file "~/.conf.d/flyspell.emacs")
;;(load-file "~/.conf.d/tex.emacs")
;;(load-file "~/.conf.d/zeal.emacs")
(load-file "~/.conf.d/eshell.emacs")
;;(load-file "~/.conf.d/ein.emacs")
;; (load-file "~/.conf.d/cnfonts.emacs")
;;=============== end of init files =======================

;;=============== cnfont ==================================
(setq cnfonts-directory "~/.conf.d/custom.d/cnfonts/win")
;;=========================================================


;; full frame
;; (toggle-frame-maximized)
;;=============== key global binding =====================
;;(global-key-binding "\C-<SPC>" 'set-mark-command)
;;(global-key-binding (kbd "<C-lwindow-f>") 'toggle-frame-maximized)
;;(global-set-key (kbd "\C-x\C-d") 'server-edit)
;;(global-unset-key (kbd "\C-x"))

;;set frame default size
(add-to-list 'default-frame-alist '(width  . 80))
(add-to-list 'default-frame-alist '(height . 30))

;;===========   menubar-mode    ==============================
(menu-bar-mode t)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode t)
;;==================== variables ==============================

;; Auto generated by cnfonts
;; <https://github.com/tumashu/cnfonts>

(defun myset-font-fun ()
  "set up cnfont light weight version scripts"
  (interactive)
  ;; (print "hello")
  (set-face-attribute
   'default nil
   :font (font-spec :name "-outline-DejaVu Sans Mono-bold-italic-normal-mono-*-*-*-*-c-*-iso10646-1"
  		    :weight 'normal
  		    :slant 'normal
  		    :size 12.5))
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (if (display-graphic-p)
  	(set-fontset-font
  	 (frame-parameter nil 'font)
  	 charset
  	 (font-spec :name "-outline-微软雅黑-normal-normal-normal-sans-*-*-*-*-p-*-iso10646-1"
  		    :weight 'normal
  		    :slant 'normal
  		    :size 15.0)))
    )
  )

;; ;; setup font for daemon
(if (daemonp)
    (add-hook 'after-make-frame-functions
	      #'(lambda (frame)
		  (select-frame frame)
		  (myset-font-fun)))
  (myset-font-fun)
  )
;; (myset-font-fun)
;; 
;;======================================================


;;==================== >> Temp Init  << ==================
;; (set-language-environment 'Chinese-GB)
(set-language-environment 'UTF-8)
;; (setq locale-coding-system 'gbk)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])

 '(cnfonts-use-system-type t)
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "59e82a683db7129c0142b4b5a35dbbeaf8e01a4b81588f8c163bd255b76f4d21" "4639288d273cbd3dc880992e6032f9c817f17c4a91f00f3872009a099f5b3f84" "ec1572b17860768fb3ce0fe0148364b7bec9581f6f1a08b066e13719c882576f" "b747fb36e99bc7f497248eafd6e32b45613ee086da74d1d92a8da59d37b9a829" default)))
 '(fci-rule-color "#383838")
 '(jdecomp-decompiler-options
   (quote
    ((cfr "--comments false" "--removeboilerplate false")
     (fernflower "-hes=0" "-hdc=0"))))
 '(jdecomp-decompiler-paths
   (quote
    ((cfr . "~/.emacs.d/decompiler/cfr-0.146.jar")
     (fernflower . "~/.emacs.d/decompiler/fernflower.jar")
     (procyon . "~/.emacs.d/decompiler/procyon-decompiler-0.5.36.jar"))))
 '(jdecomp-decompiler-type (quote fernflower))
 '(jdee-server-dir "~/myJars")
 '(lsp-ui-doc-enable t)
 '(lsp-ui-doc-max-height 20)
 '(lsp-ui-doc-max-width 80)
 '(lsp-ui-doc-position (quote at-point))
 '(lsp-ui-imenu-enable t)
 '(lsp-ui-peek-enable t)
 '(lsp-ui-sideline-enable t)
 '(magit-diff-use-overlays t)
 '(package-selected-packages
   (quote
    (dockerfile-mode tsv tsv-mode dired-x youdao-dictionary-search smart-mode-line groovy-mode gradle-mode highlight-symbol rainbow-delimiters helm-xref helm javap-mode jdecomp smartparens treemacs-magit treemacs-icons-dired treemacs-projectile treemacs-evil google-c-style autodisass-java-bytecode irony rtags ggtags projectile virtualenv company-jedi qt-pro-mode company-qml qml-mode cnfonts cyberpunk-2019-theme cyberpunk-theme org-beautify-theme org-ac yasnippet-snippets popup use-package pyim sqlite helm-dash better-defaults company py-autopep8 flymake flycheck anaconda-mode jedi zeal-at-point youdao-dictionary vbasense solarized-theme silkworm-theme powershell htmlize geeknote dictionary color-theme cmake-mode avk-emacs-themes auto-complete-clang auto-complete-auctex auctex)))
 '(python-indent-guess-indent-offset nil))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 150 :width normal)))))

;; (set-default-font "Monaco 15")
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;; p ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 150 :width normal)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
