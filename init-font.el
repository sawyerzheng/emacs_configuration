(provide 'init-font)

(defun my-load-font()
  (interactive)
  ;; (pcase system-type
  ;;   ;; font for windows
  ;;   ('windows-nt
  ;;    (set-face-attribute 'default nil :family "Cascadia Mono" :foundry "outline" :slant 'normal :weight 'normal :height 128 :width 'normal))
  ;;   ;; font linux
  ;;   ('gnu/linux
  ;;    (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'normal :height 120 :width 'normal)))

  ;; set faces font equal to `default' face
  (when (display-graphic-p)
    (cond
     ;; 4k + arch + (or wsl linux-vm)
     ((and my/linux-p (or my/wsl-p my/linux-vm-p) my/arch-p (my/4k-p))
      (set-face-attribute 'default nil :family "Cascadia Code" :foundry "ADBO" :slant 'normal :weight 'normal :height 233 :width 'normal)

      (dolist (charset '(kana han symbol cjk-misc bopomofo))
	(set-fontset-font (frame-parameter nil 'font) charset
                          (font-spec :family "Microsoft YaHei" :height 233 :width 'normal :weight 'normal)))

      ;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
      ;;   (set-fontset-font (frame-parameter nil 'font) charset
      ;;                     (font-spec :family "WenQuanYi Micro Hei Mono" :height 128 :width 'normal :weight 'normal)))
      )
     ;; wsl + arch linux + (or wsl linux-vm) + not 4k
     ((and my/linux-p (or my/wsl-p my/linux-vm-p) my/arch-p (not (my/4k-p)))
      (set-face-attribute 'default nil :family "Cascadia Code" :foundry "ADBO" :slant 'normal :weight 'normal :height 128 :width 'normal)

      (dolist (charset '(kana han symbol cjk-misc bopomofo))
	(set-fontset-font (frame-parameter nil 'font) charset
                          (font-spec :family "Microsoft YaHei" :height 128 :width 'normal :weight 'normal)))

      ;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
      ;;   (set-fontset-font (frame-parameter nil 'font) charset
      ;;                     (font-spec :family "WenQuanYi Micro Hei Mono" :height 128 :width 'normal :weight 'normal)))
      ) ;;  `中文测试好天气' `中文测试'

     ;; wsl ,`windows-sub-linux' + linux-vm
     ((and my/linux-p (or my/wsl-p my/linux-vm-p))
      ;; (set-face-attribute 'default nil :family "CaskaydiaCove Nerd Font" :foundry "outline" :slant 'normal :weight 'normal :height 128 :width 'normal)
      (set-face-attribute 'default nil :family "Cascadia Code" :foundry "outline" :slant 'normal :weight 'normal :height 128 :width 'normal)
      ;; (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'semi-bold :height 128 :width 'normal)
      )

     ;; windows
     (my/windows-p
      (set-face-attribute 'default nil :family "Cascadia Code" :foundry "outline" :slant 'normal :weight 'normal :height 128 :width 'normal))

     ;; ** linux + 4k + gnome
     ((and my/linux-p (my/4k-p) (string= (getenv "DESKTOP_SESSION") "gnome"))
      (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'normal :height 128 :width 'normal))

     ;; ** linux + 4k + cinnamon
     ((and my/linux-p (my/4k-p) (string= (getenv "DESKTOP_SESSION") "cinnamon"))
      (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'normal :height 120 :width 'normal))

     ;; ;; ** linux + 4k + gnome + daemon
     ((and my/linux-p (my/4k-p) (null (getenv "DESKTOP_SESSION")) (daemonp))
      (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'normal :height 128 :width 'normal))
     ;; linux + 4k
     ;; ** linux + 4k + not gnome (eg: qtile)
     ((and my/linux-p (my/4k-p))
      (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'normal :height 85 :width 'normal))

     ;; font linux
     (my/linux-p
      (cond
       ((member "Cascadia Code" (font-family-list))
        (set-face-attribute 'default nil :family "Cascadia Code" :foundry "outline" :slant 'normal :weight 'normal :height 128 :width 'normal))
       ((member "Source Code Pro" (font-family-list))
        (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'normal :height 120 :width 'normal))
       ((member "Ubuntu Mono" (font-family-list))
        (set-face-attribute 'default nil :family "Ubuntu Mono" :foundry "ADBO" :slant 'normal :weight 'normal :height 138 :width 'normal)))
      )
     )

    (set-face-attribute 'mode-line nil
			:family (face-attribute 'default :family)
			:height (face-attribute 'default :height)))


  ;; set emoji font
  (when (member "Segoe UI Emoji" (font-family-list))
    (set-fontset-font
     t 'symbol (font-spec :family "Segoe UI Emoji") nil 'prepend)
    ;; 有效 work
    (set-fontset-font
     t 'emoji (font-spec :family "Segoe UI Emoji") nil 'prepend)
    )

  (when (member "Noto Color Emoji" (font-family-list))
    (set-fontset-font
     t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend)
    ;; not work
    (set-fontset-font
     t 'emoji (font-spec :family "Noto Color Emoji") nil 'prepend)

    )

  )

;; (if (daemonp)
;;     (add-hook 'after-make-frame-functions
;;               (lambda (frame)
;;                 (my-load-font)))
;;   (my-load-font))

(if (daemonp)
    (add-hook 'server-after-make-frame-hook
              (lambda ()
                (my-load-font)))
  (my-load-font))

(add-hook 'my/startup-hook #'my-load-font)

(defun my/set-font-4k ()
  (interactive)
  (set-face-attribute 'default nil :family "Cascadia Code" :foundry "outline" :slant 'normal :weight 'normal :height 128 :width 'normal)
  (set-face-attribute 'mode-line nil :family "Cascadia Code" :foundry "outline" :slant 'normal :weight 'normal :height 128 :width 'normal)
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
                      (font-spec :family "Microsoft YaHei" :height 233 :width 'normal :weight 'normal))))

(when (featurep 'straight)
  (straight-use-package 'mixed-pitch))

(use-package mixed-pitch
  ;; :straight t
  :commands (mixed-pitch-mode)
  :config
  (setq mixed-pitch-variable-pitch-cursor nil))
