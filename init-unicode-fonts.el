;; -*- coding: utf-8; -*-
(use-package persistent-soft
  :straight t
  :config
  (persistent-soft-store 'hundred 100 "mydatastore")
  (persistent-soft-fetch 'hundred "mydatastore") ; 100
  (persistent-soft-fetch 'thousand "mydatastore") ; nil

  ;; quit and restart Emacs

  (persistent-soft-fetch 'hundred "mydatastore") ; 100
  )

(use-package unicode-fonts
  :straight t
  :hook (my/startup . (lambda () (ignore-errors (unicode-fonts-setup)))))

;; emoji font, ref: http://xahlee.info/emacs/emacs/emacs_set_font_emoji.html
(defun my/emoji-set-font ()
  (interactive)
  ;; set font for emoji (if before emacs 28, should come after setting symbols. emacs 28 now has 'emoji . before, emoji is part of 'symbol)
  (set-fontset-font
   t
   (if (version< emacs-version "28.1")
       '(127744 . 129744)
     'emoji)
   (cond
    ((member "Apple Color Emoji" (font-family-list)) "Apple Color Emoji")
    ((member "Noto Color Emoji" (font-family-list)) "Noto Color Emoji")
    ((member "Noto Emoji" (font-family-list)) "Noto Emoji")
    ((member "Segoe UI Emoji" (font-family-list)) "Segoe UI Emoji")
    ((member "Symbola" (font-family-list)) "Symbola"))))
(add-hook 'my/startup-hook #'my/emoji-set-font)
;; (add-hook 'my/startup-hook #'my/emoji-set-font)


(provide 'init-unicode-fonts)
