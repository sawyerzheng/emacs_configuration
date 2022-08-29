(provide 'init-spell-check)

(use-package wucuo
  :straight t
  :defer t
  ;; :hook ((text-mode prog-mode) . wucuo-start)
  :config
  (setq ispell-program-name "enchant-2"))

(use-package langtool
  :straight t
  :config
  (setq langtool-language-tool-server-jar
        (expand-file-name "langtool/languagetool-server.jar" (cond
                                                              (my/wsl-p
                                                               "/mnt/d/programs")
                                                              (t
                                                               my/program-dir))))
  (global-set-key "\C-x4w" 'langtool-check)
  (global-set-key "\C-x4W" 'langtool-check-done)
  (global-set-key "\C-x4l" 'langtool-switch-default-language)
  (global-set-key "\C-x44" 'langtool-show-message-at-point)
  (global-set-key "\C-x4c" 'langtool-correct-buffer)
  ;; (setq langtool-server-user-arguments '("-p" "8082"))
  )
