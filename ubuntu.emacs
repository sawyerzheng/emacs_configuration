;; -*- coding: utf-8; -*-
(package-initialize)
;;=============== emacs init files ========================
;; init files directory  ---> ~/.conf.d/
(load-file "~/.conf.d/default.emacs")
;; (load-file "~/.conf.d/cedet.emacs")
;;(load-file "~/.conf.d/font.emacs")
;;(load-file "~/.conf.d/coding.emacs")
(load-file "~/.conf.d/flyspell.emacs")
;;(load-file "~/.conf.d/tex.emacs")
;;(load-file "~/.conf.d/zeal.emacs")
(load-file "~/.conf.d/eshell.emacs")
;; (load-file "~/.conf.d/easyfont.emacs")
(load-file "~/.conf.d/ace-window.emacs")

;; input method
(load-file "~/.conf.d/cns-mode.emacs")
(load-file "~/.conf.d/pyim.emacs")
(load-file "~/.conf.d/liberime.emacs")

;; language
(load-file "~/.conf.d/java.emacs")
(load-file "~/.conf.d/go.emacs")
;; (load-file "~/.conf.d/cpp.emacs")
;; (load-file "~/.conf.d/rime.emacs")
;;=============== end of init files =======================

;;=============== cnfont ==================================
(load-file "~/.conf.d/cnfonts.emacs")
(setq cnfonts-directory "~/.conf.d/custom.d/cnfonts/ubuntu/")
;;=========================================================


;;=============== key global binding =====================
;;(global-key-binding "\C-<SPC>" 'set-mark-command)
;;(global-key-binding (kbd "<C-lwindow-f>") 'toggle-frame-maximized)
;; (global-set-key (kbd "M-\\") 'shrink-whitespace)

;;===========   menubar-mode    ==============================
(menu-bar-mode t)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode t)
;;(setq frame-title-format nil)
;;==================== variables ==============================

;; ============= Customizing for Screen  ===================
;; for Fonts
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 180 :width normal)))))
;;  key binding
;; binding Control-Super-f to fullscreen
(global-set-key (kbd "<C-s-268632070>") 'toggle-frame-fullscreen)
(global-set-key (kbd "<s-up>") 'toggle-frame-maximized)

;; set frame size
(add-to-list 'default-frame-alist '(width  . 100))
(add-to-list 'default-frame-alist '(height . 47))
;; maximized Starup
(toggle-frame-maximized )
;; for emacsclient font set
;; (add-to-list 'default-frame-alist '(font . "Ubuntu Mono-18"))



;;==================== >> Temp Init  << ==================
;;(set-language-environment 'Chinese-GB)
(set-language-environment 'UTF-8)
(setq locale-coding-system 'utf-8)

;; ============== for font
;; (set-face-attribute
;;  'default nil
;;  :font (font-spec :name "-DAMA-Ubuntu Mono-normal-italic-normal-*-*-*-*-*-m-0-iso10646-1"
;;                   :weight 'normal
;;                   :slant 'normal
;;                   :size 18.0))
;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;   (set-fontset-font
;;    (frame-parameter nil 'font)
;;    charset
;;    (font-spec :name "-MS  -Microsoft YaHei-normal-normal-normal-*-*-*-*-*-*-0-iso10646-1"
;;               :weight 'normal
;;               :slant 'normal
;;               :size 18.0)))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#f4eedb" "#cc1f24" "#778c00" "#a67c00" "#007ec4" "#c42475" "#11948b" "#88999b"])
 '(column-number-mode t)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#11948b")
 '(cua-normal-cursor-color "#596e76")
 '(cua-overwrite-cursor-color "#a67c00")
 '(cua-read-only-cursor-color "#778c00")
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(custom-safe-themes
   (quote
    ("13a8eaddb003fd0d561096e11e1a91b029d3c9d64554f8e897b2513dbf14b277" "015ed1c4e94502568b7c671ced6fe132bec9edf72fd732aa59780cfbe4b7927c" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "3f5f69bfa958dcf04066ab2661eb2698252c0e40b8e61104e3162e341cee1eb9" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "6096a2f93610f29bf0f6fe34307587edd21edec95073cbfcfb9d7a3b9206b399" "6bc387a588201caf31151205e4e468f382ecc0b888bac98b2b525006f7cb3307" "e11880d349e5b3f3d47e5bd6f7d9ff773ab6301e124ec7dbbbfbba5fb8482390" "33e37cd55e9ee63a8fafedb09007d2f36756abff8d551eed965a08d015f36005" "8b73cfb1b5e312c021de063ab4b194ed228b8f0414e996aa5256350cd78c3e1d" "fa2af0c40576f3bde32290d7f4e7aa865eb6bf7ebe31eb9e37c32aa6f4ae8d10" "0aefd26847666798da4ad8cd1aa6038ef1b0db92f94c24dc48d06ea445831207" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" default)))
 '(default-input-method "rime")
 '(doom-modeline-mode t)
 '(elpy-test-runner (quote elpy-test-pytest-runner))
 '(fci-rule-color "#f4eedb")
 '(highlight-changes-colors (quote ("#c42475" "#5e65b6")))
 '(highlight-symbol-colors
   (quote
    ("#ec90da49b1e9" "#ccb4e1bdd0ac" "#fb9eca14b38f" "#d89bd3eadcf9" "#de29dee7b293" "#f675cca1ae79" "#d05fdab7e079")))
 '(highlight-symbol-foreground-color "#5d737a")
 '(highlight-tail-colors
   (quote
    (("#f4eedb" . 0)
     ("#a8b84b" . 20)
     ("#66c1b3" . 30)
     ("#6fa5e7" . 50)
     ("#d6a549" . 60)
     ("#ed6e3e" . 70)
     ("#f46495" . 85)
     ("#f4eedb" . 100))))
 '(hl-bg-colors
   (quote
    ("#d6a549" "#ed6e3e" "#ff6243" "#f46495" "#837bdf" "#6fa5e7" "#66c1b3" "#a8b84b")))
 '(hl-fg-colors
   (quote
    ("#fffce9" "#fffce9" "#fffce9" "#fffce9" "#fffce9" "#fffce9" "#fffce9" "#fffce9")))
 '(hl-paren-colors (quote ("#11948b" "#a67c00" "#007ec4" "#5e65b6" "#778c00")))
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
 '(lsp-pyls-plugins-pycodestyle-ignore (quote ("W191")))
 '(lsp-ui-doc-border "#586e75")
 '(lsp-ui-doc-enable t)
 '(lsp-ui-doc-max-height 20)
 '(lsp-ui-doc-max-width 80)
 '(lsp-ui-doc-position (quote at-point))
 '(lsp-ui-imenu-enable t)
 '(lsp-ui-peek-enable t)
 '(lsp-ui-sideline-enable t)
 '(mini-modeline-enhance-visual t)
 '(mini-modeline-frame t)
 '(mini-modeline-mode nil)
 '(nrepl-message-colors
   (quote
    ("#cc1f24" "#bb3e06" "#a67c00" "#4f6600" "#a8b84b" "#005797" "#11948b" "#c42475" "#5e65b6")))
 '(org-export-with-sub-superscripts (quote {}))
 '(org-use-sub-superscripts (quote {}))
 '(package-selected-packages
   (quote
    (lsp-python-ms org-mind-map company-tabnine http lsp-ui-slideline-mode lsp-ui evil go-eldoc go-autocomplete go-errcheck flycheck-golangci-lint go-snippets go-mode liberime rime yaml-mode mini-modeline cnfonts logview diminish all-the-icons-ivy all-the-icons-ivy-rich all-the-icons-dired all-the-icons doom-modeline imenus imenu-anywhere imenu-list linum-relative nlinum linum-off htmlize clang-format+ clang-format format-all e2wm edbi eziam-theme zeal-at-point youdao-dictionary yasnippet-snippets whitespace-cleanup-mode web-mode virtualenvwrapper use-package treemacs-projectile treemacs-magit treemacs-icons-dired treemacs-evil solarized-theme smartparens silkworm-theme realgud rainbow-delimiters pyim org-ac meghanada lsp-treemacs lsp-java leuven-theme jdecomp ivy-rtags irony highlight-symbol helm-lsp groovy-mode google-c-style flycheck-rtags elpy dockerfile-mode devdocs dap-mode cyberpunk-theme company-rtags company-c-headers cmake-mode cmake-ide autodisass-java-bytecode)))
 '(pdf-view-midnight-colors (quote ("#eeeeee" . "#000000")))
 '(pos-tip-background-color "#f4eedb")
 '(pos-tip-foreground-color "#5d737a")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#778c00" "#f4eedb" 0.2))
 '(term-default-bg-color "#fffce9")
 '(term-default-fg-color "#596e76")
 '(tool-bar-mode nil)
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#cc1f24")
     (40 . "#bb0159ab189c")
     (60 . "#b11d6bfb0f58")
     (80 . "#a67c00")
     (100 . "#976e81f50000")
     (120 . "#8fd084ae0000")
     (140 . "#87e987410000")
     (160 . "#7faa89b10000")
     (180 . "#778c00")
     (200 . "#690f8e693f47")
     (220 . "#5efe8fb4534a")
     (240 . "#5165910f6634")
     (260 . "#3d37927d78ad")
     (280 . "#11948b")
     (300 . "#1ae68b4ea1e6")
     (320 . "#194086e8ad46")
     (340 . "#127b8279b8a2")
     (360 . "#007ec4"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#fffce9" "#f4eedb" "#990001" "#cc1f24" "#4f6600" "#778c00" "#785700" "#a67c00" "#005797" "#007ec4" "#93004d" "#c42475" "#006d68" "#11948b" "#596e76" "#88999b")))
 '(xterm-color-names
   ["#f4eedb" "#cc1f24" "#778c00" "#a67c00" "#007ec4" "#c42475" "#11948b" "#002b37"])
 '(xterm-color-names-bright
   ["#fffce9" "#bb3e06" "#98a6a6" "#88999b" "#596e76" "#5e65b6" "#5d737a" "#00212b"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
