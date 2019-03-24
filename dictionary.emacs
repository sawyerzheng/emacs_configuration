
;;=================== global key biding ====================
(global-set-key "\C-c\C-d" 'dictionary-search)
;;(global-set-key "\C-cd" 'dictionary-search)
(global-set-key "\C-c\C-s" 'youdao-dictionary-search-at-point+)
(global-set-key "\C-cs" 'youdao-dictionary-search-at-point+)

;;===================== outline ---> foldout ===============
(eval-after-load "outline" '(require 'foldout))

;;===================== dictionary  package ================
(setq dictionary-server "localhost")

;;================ search through en.wikipedia.org ===========
(require 'browse-url) ; part of gnu emacs

;; Actually, it just search the word by opening a new tab
;; in the real web browse which is not the eww in emacs.
(defun my-lookup-wikipedia ()
  "Look up the word under cursor in Wikipedia.
If there is a text selection (a phrase), use that.

This command switches to browser."
  (interactive)
  (let (word)
    (setq word
          (if (use-region-p)
              (buffer-substring-no-properties (region-beginning) (region-end))
            (current-word)))
    (setq word (replace-regexp-in-string " " "_" word))
    (browse-url (concat "http://en.wikipedia.org/wiki/" word))
    ;; (eww myUrl) ; emacs's own browser
    ))


(global-set-key "\C-c\C-w" 'my-lookup-wikipedia)
;;========================== end ===== wikipedia =====================
