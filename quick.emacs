;; -*- coding: utf-8; -*-
;; load path  
;; (package-initialize)
;; (add-to-list 'load-path "~/.emacs.d/elpa/")
;; ================= use-package ====================
;; (condition-case nil
;;     (require 'use-package)
;;   (file-error
;;    (require 'package)
;;    (package-initialize)
;;    (package-refresh-contents)
;;    (package-install 'use-package)
;;    (require 'use-package)))

;; ================= boost.python ================
;; (load-file "~/.conf.d/jam-mode.emacs")
;; (if (equal system-type 'gnu/linux)
;;     (progn
;;       (add-to-list 'load-path "~/.conf.d/extra.d/")
;;       (add-to-list 'load-path "/home/sawyer/.conf.d/extra.d/")
;;       (add-to-list 'load-path "/home/sawyer/.conf.d/extra.d/auto-complete/")
;;       (require 'jam-mode)
;;       (add-to-list 'auto-mode-alist '("[Jj]amfile\\'" . jam-mode))
;;       (add-to-list 'auto-mode-alist '("\\.jam\\'" . jam-mode))
;;       ))

;; ================ elpa adn use-package ================
;; (ignore-errors
;;   (load-file "~/.conf.d/packages.emacs")
;;   (load-file "/home/sawyer/.conf.d/packages.emacs")
;;   )


;; ================= auto-complete mode ============
;; (if (equal system-type 'gnu/linux)
;;     (progn

;;       ;; (use-package popup
;;       ;; 	:ensure t)
;;       ;; (use-package auto-complete
;;       ;; 	:ensure t)

;;       ;; * old backup, for speed
;;       (add-to-list 'load-path "~/.conf.d/extra.d/popup/")      
;;       (add-to-list 'load-path "/home/sawyer/.conf.d/extra.d/popup")
;;       (add-to-list 'load-path "~/.conf.d/extra.d/popup/auto-complete/")
;;       (add-to-list 'load-path "/home/sawyer/.conf.d/extra.d/popup/auto-complete/")

;;       (require 'auto-complete)
;;       ;; global
;;       (global-auto-complete-mode t)
;;       (require 'auto-complete-config)

;;       (ac-config-default)

;;       ;; popup
;;       (require 'pos-tip)
;;       (setq ac-quick-help-prefer-pos-tip t)

;;       ;; 设置tab键的使用模式--??
;;       (setq ac-dwim t)


;;       ;;使用fuzzy功能
;;       (setq ac-fuzzy-enable t)
;;       ))


;;====================== search ===============
(global-set-key (kbd "C-S-s") 'isearch-forward-symbol-at-point)


;; ;;======================================
;; ;; (load-file "~/.conf.d/font.emacs")
;; (load-file "~/.conf.d/pyim.emacs")
;; (require 'cmake-mode)



;; ;; full frame
;; (toggle-frame-maximized)
;; ;;=============== key global binding =====================
;; ;;(global-key-binding "\C-<SPC>" 'set-mark-command)
;; ;;(global-key-binding (kbd "<C-lwindow-f>") 'toggle-frame-maximized)
;; ;;(global-set-key (kbd "\C-x\C-d") 'server-edit)
;; ;;(global-unset-key (kbd "\C-x"))

;; ;;set frame default size
;; (add-to-list 'default-frame-alist '(width  . 85))
;; (add-to-list 'default-frame-alist '(height . 33))

(setq visible-bell 1)

;; ;;===========   menubar-mode    ==============================
(menu-bar-mode 0)

;;================ code line number mode ================
;;(global-linum-mode 1) ; always show line numbers 
(setq linum-format "%2d")  ;set format

;;=============== program-mode =====================
;; add line mode hook for program-mode
(add-hook 'prog-mode-hook (lambda ()
			    "enable line number mode"
			    ;;			     (local-set-key (kbd "C-S-o") 'open-newline-forword)
                            (display-line-numbers-mode)
			    ;; (linum-mode 1)
			    (subword-mode 1)
			    ;; (whitespace-cleanup-mode 1)
			    ))

(if (eq system-type 'cygwin)
    (progn
      (menu-bar-mode 0))
  (progn
    (if (boundp 'tool-bar-mode)
	(tool-bar-mode 0))
    (if (boundp 'scroll-bar-mode)
	(scroll-bar-mode 0))
    ))

;;=============== org mode =======================
(setq org-edit-src-content-indentation 0)
(setq org-src-preserve-indentation nil)
(add-hook 'org-mode-hook #'org-indent-mode)
(with-eval-after-load "org"
  (require 'org-indent))

;; (scroll-bar-mode 0)
;; (column-number-mode t)

;;(set-language-environment 'Chinese-GB)
;; (set-language-environment 'UTF-8)
;; (setq locale-coding-system 'gbk)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-safe-themes
   (quote
    ("59e82a683db7129c0142b4b5a35dbbeaf8e01a4b81588f8c163bd255b76f4d21" "4639288d273cbd3dc880992e6032f9c817f17c4a91f00f3872009a099f5b3f84" "ec1572b17860768fb3ce0fe0148364b7bec9581f6f1a08b066e13719c882576f" "b747fb36e99bc7f497248eafd6e32b45613ee086da74d1d92a8da59d37b9a829" default))))


;; ;; (delete-other-windows)
;; (maximize-window (selected-window))

;; (add-hook 'window-setup-hook
;; 	  '(lambda ()
;; 	     "delete the GNU Emacs buffer"
;; 	     (kill-buffer "*GNU Emacs*")))



;; ============ font =============
;; for linux
;; (if (equal system-type 'gnu/linux)
;;     (set-face-attribute
;;      'default nil
;;      :font (font-spec :name "-DAMA-Ubuntu Mono-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"
;;                       :weight 'normal
;;                       :slant 'normal
;;                       :size 16.0))
;;   (if (boundp 'setfontset-font)
;;       (dolist (charset '(kana han symbol cjk-misc bopomofo))
;; 	(set-fontset-font
;; 	 (frame-parameter nil 'font)
;; 	 charset
;; 	 (font-spec :name "-MS  -Microsoft YaHei-normal-normal-normal-*-*-*-*-*-*-0-iso10646-1"
;; 		    :weight 'normal
;; 		    :slant 'normal
;; 		    :size 16.5)))))

;; for windows and cygwin, msys2
;; (if (or (equal system-type 'windows-nt)
;; 	(equal system-type 'cygwin))
;;     (custom-set-faces
;;      '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 120 :width normal))))))
;; (custom-set-faces
     ;; '(default ((t (:family "Monaco" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))

  


(global-set-key (kbd "M-o") #'other-window)
(column-number-mode t)
;; ========== splash screen *GNU Emacs* buffer ============
(setq inhibit-startup-screen t)


;; for windows
(if (or (equal system-type 'cygwin)
	(equal system-type 'windows-nt)
	(equal system-type 'gnu/linux))
    (progn
      (custom-set-variables
       '(custom-enabled-themes (quote (tsdh-dark))))
      ))


(if (eq system-type 'windows-nt)
    (progn
      (set-face-attribute 'default nil :family "Consolas" :height 120)
      (set-face-attribute 'mode-line nil :family "Consolas" :height 120))
  )
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
  (back-to-indentation)
)
(global-set-key (kbd "M-Y") #'duplicate-line)

(fido-vertical-mode +1)

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 120 :width normal))))
;;  '(mode-line ((t (:background "gray30" :box (:line-width 1 :color "red") :family "Consolas")))))

(put 'upcase-region 'disabled nil)
