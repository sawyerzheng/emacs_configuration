;; -*- coding: utf-8; -*-
(use-package fanyi
  :straight t
  :bind (("C-c s d f" . fanyi-dwim)
         ("C-c s d d" . fanyi-dwim2)
         ("C-c s d h" . fanyi-from-history)))

;; part of codes from centuar-emacs
(use-package youdao-dictionary
  :straight t
  :commands youdao-dictionary-play-voice-of-current-word
  :bind (("C-c s y y" . my-youdao-dictionary-search-at-point))
  :bind (("C-c s y i" . youdao-dictionary-search-from-input)
         ("C-c s y v" . youdao-dictionary-play-voice-at-point)
         :map youdao-dictionary-mode-map
         ("h" . my-youdao-dictionary-help)
         ("?" . my-youdao-dictionary-help))
  :config
  (defun my-youdao-search-at-point ()
    "youdao search with posframe on gui and with popup on tty"
    (interactive)
    (if (posframe-workable-p)
        (youdao-dictionary-search-at-point-posframe)
      (youdao-dictionary-search-at-point+)))

  (setq url-automatic-caching t
        youdao-dictionary-use-chinese-word-segmentation t) ; 中文分词

  (defun my-youdao-dictionary-search-at-point ()
    "Search word at point and display result with `posframe', `pos-tip', or buffer."
    (interactive)
    (if (display-graphic-p)
        (if (posframe-workable-p)
            (youdao-dictionary-search-at-point-posframe)
          (youdao-dictionary-search-at-point-tooltip))
      (youdao-dictionary-search-at-point)))


  (with-no-warnings
    (with-eval-after-load 'hydra
      (defhydra youdao-dictionary-hydra (:color blue)
        ("p" youdao-dictionary-play-voice-of-current-word "play voice of current word")
        ("y" youdao-dictionary-play-voice-at-point "play voice at point")
        ("q" quit-window "quit")
        ("C-g" nil nil)
        ("h" nil nil)
        ("?" nil nil))
      (defun my-youdao-dictionary-help ()
        "Show help in `hydra'."
        (interactive)
        (let ((hydra-hint-display-type 'message))
          (youdao-dictionary-hydra/body))))))
;;=================== global key biding ====================
;;(global-set-key "\C-c\C-d" 'dictionary-search)
;; (global-set-key "\C-cd" 'dictionary-search)
;; (global-set-key "\C-c\C-s" 'youdao-dictionary-search-at-point+)
;; (global-set-key "\C-cs" 'youdao-dictionary-search-at-point+)

;;===================== outline ---> foldout ===============
;; (with-eval-after-load "outline"
  ;; (require 'foldout))

;;===================== dictionary  package ================
;; (setq dictionary-server "localhost")

;;================ search through en.wikipedia.org ===========
(use-package browse-url
  :straight (:type built-in)
  :config
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
  :bind ("C-c s w" . my-lookup-wikipedia))

;;========================== end ===== wikipedia =====================

(use-package popweb
  :straight (popweb :type git :host github :repo "manateelazycat/popweb" :files (:defaults "extension/dict" "extension/latex" "extension/org-roam" "extension/url-preview" "*"))
  :init
  (my-add-extra-folder-to-load-path "popweb" '("extension/dict" "extension/latex" "extension/org-roam" "extension/url-preview"))
  :commands (popweb-dict-bing-pointer popweb-dict-youdao-pointer)
  :bind (("C-c s d b" . popweb-dict-bing-pointer)
         ("C-c s d y" . popweb-dict-youdao-pointer))
  :demand t
  :hook ((org-mode latex-mode) . popweb-latex-mode)
  :config
  (require 'popweb-dict-bing)
  (require 'popweb-dict-youdao)
  (require 'popweb-latex)
  (setq popweb-python-command (if my/windows-p
                                  "d:/soft/miniconda3/envs/tools/python"
                                "~/miniconda3/envs/tools/bin/python")))

(provide 'init-dictionary)
