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
(load-file "~/.conf.d/ace-window.emacs")
(load-file "~/.conf.d/cpp.emacs")

;;=============== cnfont ==================================
(setq cnfonts-directory "~/.conf.d/custom.d/cnfonts/deepin/")
;;=========================================================

(defun myset-font-fun ()
  "set up cnfont light weight version scripts"
  (interactive)
  ;; (print "hello")
  (set-face-attribute
   'default nil
   :font (font-spec :name "-DAMA-Ubuntu Mono-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"
                    :weight 'normal
                    :slant 'normal
                    :size 15.0))
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (if (display-graphic-p)
        (set-fontset-font
         (frame-parameter nil 'font)
         charset
         (font-spec :name "-WQYF-WenQuanYi Micro Hei Mono-normal-normal-normal-*-*-*-*-*-*-0-iso10646-1"
                    :weight 'normal
                    :slant 'normal
                    :size 15.5)))
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
;;========================================================
(setq default-input-method "pyim")
;;=============== end of init files =======================
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;=============== key global binding =====================
;;(global-key-binding "\C-<SPC>" 'set-mark-command)
;;(global-key-binding (kbd "<C-lwindow-f>") 'toggle-frame-maximized)
;;===========   menubar-mode    ==============================
(menu-bar-mode t)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode t)
;;==================== variables ==============================


;; set frame size
(toggle-frame-maximized )
(add-to-list 'default-frame-alist '(width  . 115))
(add-to-list 'default-frame-alist '(height . 60))


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
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   (quote
    ("6bc387a588201caf31151205e4e468f382ecc0b888bac98b2b525006f7cb3307" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "0aefd26847666798da4ad8cd1aa6038ef1b0db92f94c24dc48d06ea445831207" "fa2af0c40576f3bde32290d7f4e7aa865eb6bf7ebe31eb9e37c32aa6f4ae8d10" "85d1dbf2fc0e5d30f236712b831fb24faf6052f3114964fdeadede8e1b329832" default)))
 '(elpy-rpc-virtualenv-path "/home/sawyer/.virtualenvs/env36")
 '(fci-rule-color "#073642")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(hl-paren-colors (quote ("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900")))
 '(hl-sexp-background-color "#efebe9")
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
 '(lsp-ui-doc-enable nil)
 '(lsp-ui-doc-max-height 20)
 '(lsp-ui-doc-max-width 80)
 '(lsp-ui-doc-position (quote at-point))
 '(lsp-ui-imenu-enable nil)
 '(lsp-ui-peek-enable nil)
 '(lsp-ui-sideline-enable nil)
 '(magit-diff-use-overlays t)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(package-selected-packages
   (quote
    (lsp-java gradle-mode docker dockerfile-mode cnfonts zeal-at-point youdao-dictionary yasnippet-snippets yasnippet-classic-snippets whitespace-cleanup-mode web-mode virtualenvwrapper use-package treemacs-projectile treemacs-magit treemacs-icons-dired treemacs-evil solarized-theme smartparens silkworm-theme realgud rainbow-delimiters pyim org-ac meghanada lsp-ui lsp-treemacs leuven-theme jdecomp ivy-rtags irony ido-yes-or-no highlight-symbol helm-lsp groovy-mode google-c-style gnu-elpa-keyring-update flycheck-rtags find-file-in-project elpy devdocs dap-mode cyberpunk-theme company-rtags company-lsp company-c-headers cmake-mode cmake-ide autodisass-java-bytecode amx ac-rtags)))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(rtags-path "/home/sawyer/backup.d/rtags/rtags-2.34/bin/")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c8805d801780")
     (60 . "#bec073400bc0")
     (80 . "#b58900")
     (100 . "#a5008e550000")
     (120 . "#9d0091000000")
     (140 . "#950093aa0000")
     (160 . "#8d0096550000")
     (180 . "#859900")
     (200 . "#66aa9baa32aa")
     (220 . "#57809d004c00")
     (240 . "#48559e556555")
     (260 . "#392a9faa7eaa")
     (280 . "#2aa198")
     (300 . "#28669833af33")
     (320 . "#279993ccbacc")
     (340 . "#26cc8f66c666")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
