(provide 'init-c)

(use-package modern-cpp-font-lock
  :straight t
  :defer t
  :commands (modern-c++-font-lock-mode modern-c++-font-lock-global-mode)
  :hook (c++-mode . modern-c++-font-lock-mode))

;; qt keywords setup
(use-package cc-mode
  :config
  (defun c-mode-style-setup ()
    (interactive)
    ;; cpp font lock.
    ;; (modern-c++-font-lock-global-mode t)

    ;; base-style
    (c-set-style "stroustrup")

    ;; qt keywords and stuff ...
    ;; set up indenting correctly for new qt kewords
    (setq c-protection-key (concat "\\<\\(public\\|public slot\\|protected"
                                   "\\|protected slot\\|private\\|private slot"
                                   "\\)\\>")
          c-C++-access-key (concat "\\<\\(signals\\|public\\|protected\\|private"
                                   "\\|public slots\\|protected slots\\|private slots"
                                   "\\)\\>[ \t]*:"))
    (progn
      ;; modify the colour of slots to match public, private, etc ...
      (font-lock-add-keywords 'c++-mode
                              '(("\\<\\(slots\\|signals\\)\\>" . font-lock-type-face)))
      ;; make new font for rest of qt keywords
      (make-face 'qt-keywords-face)
      (set-face-foreground 'qt-keywords-face "DeepSkyBlue1")
      ;; qt keywords
      (font-lock-add-keywords 'c++-mode
                              '(("\\<Q_OBJECT\\>" . 'qt-keywords-face)))
      (font-lock-add-keywords 'c++-mode
                              '(("\\<SIGNAL\\|SLOT\\>" . 'qt-keywords-face)))
      (font-lock-add-keywords 'c++-mode
                              '(("\\<Q[A-Z][A-Za-z]\\>" . 'qt-keywords-face)))))
  :hook ((c-mode c++-mode c-mode-common) . c-mode-style-setup)
  )

;; cmake
(use-package cmake-mode
  :straight t
  :commands (cmake-mode))

;; 太老，无法使用
;; (use-package cmake-project
;;   :straight t
;;   :hook ((c-mode c++-mode) . maybe-cmake-project-mode)
;;   :config
;;   (defun maybe-cmake-project-mode ()
;;     (if (or (file-exists-p "CMakeLists.txt")
;;             (file-exists-p (expand-file-name "CMakeLists.txt" (car (project-roots (project-current))))))
;;         (cmake-project-mode))))

(use-package eldoc-cmake
  :straight t
  :hook (cmake-mode . eldoc-cmake-enable))

(use-package cmake-integration
  :straight (:type git :host github :repo "darcamo/cmake-integration")
  :commands (cmake-integration-save-and-compile))
