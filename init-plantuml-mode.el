;; -*- coding: utf-8; -*-

(use-package plantuml-mode
  :straight t
  :mode (("\\.plantuml\\'" . plantuml-mode)
         ("\\.\\(plantuml\\|pum\\|plu\\|puml\\)\\'" . plantuml-mode))

  :config
  (setq plantuml-default-exec-mode
        'jar
        ;; 'server
        )
  ;; set indent
  (setq plantuml-indent-level 4)
  (setq plantuml-jar-path "~/programs/plantuml.jar")
  (setq org-plantuml-jar-path plantuml-jar-path)
  (if (and (eq plantuml-default-exec-mode 'jar) (not (file-exists-p plantuml-jar-path)))
      (progn
        (plantuml-download-jar)))

  ;; set output type depends on screen size
  ;; (setq plantuml-output-type
  ;;       (if (or (not (boundp 'x-display-pixel-width)) (> (x-display-pixel-height) 1080))
  ;;           "txt"
  ;;         "png"))


  (add-hook 'image-mode-hook (lambda ()
                               (if (equal (buffer-name) "*PLANTUML Preview*")
                                   (progn
                                     ;; (scroll-bar-mode 1)
                                     ;; (horizontal-scroll-bar-mode 1)
                                     (when my/4k-p
                                       (image-increase-size 20 1))
                                     ;; (sleep-for 10)
                                     ;; (image-toggle-display)
                                     ;; (image-toggle-display)

                                     ;; (goto-char 1)
                                     ;; (image-increase-size 2)
                                     ;; (set-mark (point-min))
                                     ;; (goto-char (point-max))
                                     ;; (image-increase-size 2 2)
                                     ))))
  ;; (add-hook 'nxml-mode-hook (lambda ()
  ;;                             (when (equal (buffer-name) "*PLANTUML PREVIEW*")
  ;;                               (image-toggle-display))))
  )

(provide 'init-plantuml-mode)
