(use-package doom-themes
  :straight t)
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
   ;; wsl ,`windows-sub-linux'
   ((and my/linux-p (or my/wsl-p my/linux-vm-p))
    (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'semi-bold :height 128 :width 'normal))

   ;; windows
   (my/windows-p
    (set-face-attribute 'default nil :family "Cascadia Mono" :foundry "outline" :slant 'normal :weight 'normal :height 128 :width 'normal))

   ;; font linux
   (my/linux-p
    (set-face-attribute 'default nil :family "Source Code Pro" :foundry "ADBO" :slant 'normal :weight 'normal :height 120 :width 'normal)))

  (set-face-attribute 'mode-line nil
                      :family (face-attribute 'default :family)
                      :height (face-attribute 'default :height))
  
  )

;; no save theme prop
(setq custom-safe-themes t)

;; (my-load-font)
(add-hook 'after-init-hook #'my-load-font)

;; theme
(setq my-selected-theme 'doom-one)

(defun my-load-theme ()
  (interactive)
  (load-theme my-selected-theme))

(add-hook 'after-init-hook #'my-load-theme)

(provide 'init-font-and-theme)
