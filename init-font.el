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
  (cond

   ((and my/linux-p (or my/wsl-p my/linux-vm-p) my/arch-p my/4k-p)
    (set-face-attribute 'default nil :family "Cascadia Code" :foundry "ADBO" :slant 'normal :weight 'normal :height 233 :width 'normal)

    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font) charset
                        (font-spec :family "Microsoft YaHei" :height 233 :width 'normal :weight 'normal)))

    ;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
    ;;   (set-fontset-font (frame-parameter nil 'font) charset
    ;;                     (font-spec :family "WenQuanYi Micro Hei Mono" :height 128 :width 'normal :weight 'normal)))
    )
   ;; wsl + arch linux
   ((and my/linux-p (or my/wsl-p my/linux-vm-p) my/arch-p)
    (set-face-attribute 'default nil :family "Cascadia Code" :foundry "ADBO" :slant 'normal :weight 'normal :height 128 :width 'normal)

    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font) charset
                        (font-spec :family "Microsoft YaHei" :height 128 :width 'normal :weight 'normal)))

    ;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
    ;;   (set-fontset-font (frame-parameter nil 'font) charset
    ;;                     (font-spec :family "WenQuanYi Micro Hei Mono" :height 128 :width 'normal :weight 'normal)))
    ) ;;  `中文测试好天气' `中文测试'



   ;; wsl ,`windows-sub-linux'
   ((and my/linux-p (or my/wsl-p my/linux-vm-p))
    (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'semi-bold :height 128 :width 'normal))

   ;; windows
   (my/windows-p
    (set-face-attribute 'default nil :family "Cascadia Code" :foundry "outline" :slant 'normal :weight 'normal :height 128 :width 'normal))

   ;; font linux
   (my/linux-p
    (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'normal :height 120 :width 'normal)))

  (set-face-attribute 'mode-line nil
                      :family (face-attribute 'default :family)
                      :height (face-attribute 'default :height))

  )
;; (my-load-font)
(if my/graphic-p
    (add-hook 'after-init-hook #'my-load-font))
