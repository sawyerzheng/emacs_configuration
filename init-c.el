(use-package modern-cpp-font-lock
  :straight t
  :defer t
  :commands (modern-c++-font-lock-mode modern-c++-font-lock-global-mode)
  :hook (c++-mode . modern-cpp-font-lock-global-mode))

;; qt keywords setup
(use-package cc-mode
  :config
  (defun c-mode-style-setup ()
    (interactive)
    (require)
    ;; cpp font lock.
    (modern-c++-font-lock-global-mode t)

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
  :hook ((c-mode c++-mode c-mode-common) . c-mode-style-setup))
