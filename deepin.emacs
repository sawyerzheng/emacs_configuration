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

;; for rtags
;; (setq rtags-path "/home/sawyer/backup.d/rtags/rtags-2.34/bin/")
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
 '(cmake-ide-build-dir "build")
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(elpy-test-runner (quote elpy-test-pytest-runner))
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
 '(package-selected-packages
   (quote
    (imenus imenu-anywhere imenu-list zeal-at-point youdao-dictionary yasnippet-snippets whitespace-cleanup-mode web-mode virtualenvwrapper use-package treemacs-projectile treemacs-magit treemacs-icons-dired treemacs-evil smartparens realgud rainbow-delimiters pyim org-ac meghanada lsp-ui lsp-treemacs lsp-java jdecomp ivy-rtags irony-eldoc highlight-symbol helm-lsp groovy-mode google-c-style flycheck-rtags flycheck-irony flycheck-clang-tidy flycheck-clang-analyzer elpy eldoc-cmake dockerfile-mode devdocs dap-mode company-rtags company-c-headers cmake-mode cmake-ide clang-format+ autodisass-java-bytecode)))
 '(rtags-path "/home/sawyer/backup.d/rtags/rtags-2.34/bin/"))
