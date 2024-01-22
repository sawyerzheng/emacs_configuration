(use-package sis
  :straight t
  :commands (sis-set-english
             sis-set-other
             sis-get
             sis-switch
             sis-context-mode
             sis-global-respect-mode
             sis-log-mode
             sis-inline-mode
             sis-auto-refresh-mode
             sis-global-inline-mode
             sis-global-context-mode
             sis-global-cursor-color-mode
             sis-prefix-override-buffer-enable
             sis-prefix-override-buffer-disable)
  :config
  (cond
   ;; (my/wsl-p
   ;; (sis-ism-lazyman-config "1033" "2052" 'im-select))

   ;; (sis-ism-lazyman-config nil "rime" 'native)scra
   (my/windows-p
    (sis-ism-lazyman-config "1033" "2052" 'im-select))
   (my/linux-p
    (sis-ism-lazyman-config "xkb:us::eng" "rime" 'ibus)))

  ;; enable the /cursor color/ mode
  (sis-global-cursor-color-mode t)
  ;; enable the /respect/ mode
  (sis-global-respect-mode t)
  ;; enable the /context/ mode for all buffers
  (sis-global-context-mode t)
  ;; enable the /inline english/ mode for all buffers
  (sis-global-inline-mode t)
  )


(provide 'init-sis)
