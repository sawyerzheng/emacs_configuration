;; -*- coding: utf-8; -*-
;; :ref https://github.com/DarthFennec/highlight-indent-guides
(use-package highlight-indent-guides
  :straight t
  :hook (prog-mode . highlight-indent-guides-mode)
  :hook (highlight-indent-guides-mode . (lambda ()
                                          (my/highlight-indent-guides-set-faces-fn)
                                          (ignore-errors (highlight-indent-guides-auto-set-faces))
                                          (my/highlight-indent-guides-set-faces-fn)))
  :commands (highlight-indent-guides-mode
             highlight-indent-guides-auto-set-faces)

  :init
  ;; (setq highlight-indent-guides-method 'character)
  ;; (set-face-background 'highlight-indent-guides-odd-face "darkgray")
  ;; (set-face-background 'highlight-indent-guides-even-face "dimgray")
  ;; (set-face-foreground 'highlight-indent-guides-character-face "dimgray")

  ;; default setting
  ;; (setq highlight-indent-guides-method 'fill)
  (custom-set-variables '(highlight-indent-guides-method 'character))

  (setq highlight-indent-guides-auto-odd-face-perc 31
        highlight-indent-guides-auto-even-face-perc 40
        highlight-indent-guides-auto-character-face-perc 50)

  ;; (set-face-background 'highlight-indent-guides-odd-face 'unspecified)
  ;; (set-face-background 'highlight-indent-guides-even-face 'unspecified)

  (defun my/highlight-indent-guides-set-faces-fn ()
    (interactive)
    (cond ((string-prefix-p "modus-vivendi" (symbol-name (car custom-enabled-themes)))
           (progn
             (custom-set-variables '(highlight-indent-guides-method 'character))

             (set-face-background 'highlight-indent-guides-odd-face "darkgray")
             (set-face-background 'highlight-indent-guides-even-face "dimgray")
             (set-face-foreground 'highlight-indent-guides-character-face "dimgray")))
          (t
           (progn
             (custom-set-variables '(highlight-indent-guides-method 'character))

             (setq highlight-indent-guides-auto-odd-face-perc 31
                   highlight-indent-guides-auto-even-face-perc 40
                   highlight-indent-guides-auto-character-face-perc 50))))
    )
  (my/highlight-indent-guides-set-faces-fn)
  (unless (display-graphic-p)
    ;;(setq highlight-indent-guides-auto-enabled nil)
    (setq highlight-indent-guides-suppress-auto-error t)
    )

  )


(provide 'init-highlight-indent-guides)
