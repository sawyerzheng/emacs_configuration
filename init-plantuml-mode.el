;; -*- coding: utf-8; -*-
(use-package plantuml-mode
  :straight t
  :config
  ;; set exec-mode and check if need to download jar file

  (setq plantuml-default-exec-mode
        'jar
        ;; 'server
        )
  (setq plantuml-jar-path "~/programs/plantuml.jar")
  (setq org-plantuml-jar-path plantuml-jar-path)
  (if (and (eq plantuml-default-exec-mode 'jar) (not (file-exists-p plantuml-jar-path)))
      (progn
        (plantuml-download-jar)))

  (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
  (add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))

  ;; set output type depends on screen size
  (setq plantuml-output-type
        (if (or (not (boundp 'x-display-pixel-width)) (> (x-display-pixel-height) 1080))
            "txt"
          "png"))

  ;; integrate with org-mode
  (add-to-list
   'org-src-lang-modes '("plantuml" . plantuml))
  (add-to-list
   'org-src-lang-modes '("puml" . plantuml))
  (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))

  (add-hook 'image-mode-hook (lambda ()
                               (if (equal (buffer-name) "*PLANTUML Preview*")
                                   (progn
                                     (scroll-bar-mode 1)
                                     (horizontal-scroll-bar-mode 1))))))

(provide 'init-plantuml-mode)
