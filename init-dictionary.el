;; -*- coding: utf-8; -*-
(my/straight-if-use 'fanyi)
(use-package fanyi
  :bind (("C-c s d f" . fanyi-dwim)
         ("C-c s d d" . fanyi-dwim2)
         ("C-c s d h" . fanyi-from-history))
  :config
  (custom-set-variables
   '(fanyi-providers '(fanyi-youdao-thesaurus-provider
                       fanyi-haici-provider
                       ;; fanyi-etymon-provider
                       ;; fanyi-longman-provider
                       )))
  (defun my/fanyi-custom-more ()
    (interactive)
    (custom-set-variables
     '(fanyi-providers '(fanyi-youdao-thesaurus-provider
                         fanyi-haici-provider
                         fanyi-etymon-provider
                         fanyi-longman-provider))))
  (defun my/fanyi-custom-less ()
    (interactive)
    (custom-set-variables
     '(fanyi-providers '(fanyi-youdao-thesaurus-provider
                         fanyi-haici-provider
                         ;; fanyi-etymon-provider
                         ;; fanyi-longman-provider
                         )))))

(my/straight-if-use 'bing-dict)
(use-package bing-dict
  :commands (bing-dict-brief
             my/bing-dict-brief)
  :config
  (defun my/bing-dict-brief (&optional arg)
    "Show the explanation of WORD from Bing in the echo area."
    (interactive "P")
    (let* ((default (if (use-region-p)
                        (buffer-substring-no-properties
                         (region-beginning) (region-end))
                      (let ((text (thing-at-point 'word)))
                        (if text (substring-no-properties text)))))
           (prompt (if (stringp default)
                       (format "Search Bing dict (default \"%s\"): " default)
                     "Search Bing dict: "))
           (word (if arg
                     (read-string prompt nil 'bing-dict-history default)
                   default))
           (sync-p nil))


      (and bing-dict-cache-auto-save
           (not bing-dict--cache)
           (bing-dict--cache-load))

      (let ((cached-result (and (listp bing-dict--cache)
                                (car (assoc-default word bing-dict--cache)))))
        (if cached-result
            (progn
              ;; update cached-result's time
              (setcdr (assoc-default word bing-dict--cache) (time-to-seconds))
              (message cached-result))
          (save-match-data
            (if sync-p
                (with-current-buffer (url-retrieve-synchronously
                                      (concat bing-dict--base-url
                                              (url-hexify-string word))
                                      t t)
                  (bing-dict-brief-cb nil (decode-coding-string word 'utf-8)))
              (url-retrieve (concat bing-dict--base-url
                                    (url-hexify-string word))
                            'bing-dict-brief-cb
                            `(,(decode-coding-string word 'utf-8))
                            t
                            t))))))))


;; part of codes from centuar-emacs
(my/straight-if-use 'youdao-dictionary)
(use-package youdao-dictionary
  :commands youdao-dictionary-play-voice-of-current-word
  :bind (("C-c s y y" . my-youdao-dictionary-search-at-point))
  :bind (("C-c s y i" . youdao-dictionary-search-from-input)
         ("C-c s y v" . youdao-dictionary-play-voice-at-point)
         :map youdao-dictionary-mode-map
         ("h" . my-youdao-dictionary-help)
         ("?" . my-youdao-dictionary-help))
  :config
  (setq youdao-dictionary-app-key "16f39ae02e5c0a27"
        youdao-dictionary-secret-key "v6j2BVYJP3M2fOvrW9ZBRx3qUwE3CiBA")
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
(my/straight-if-use '(browse-url :type built-in))
(use-package browse-url
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
(my/straight-if-use '(popweb :type git :host github :repo "manateelazycat/popweb" :files (:defaults "extension/dict" "extension/latex" "extension/org-roam" "extension/url-preview" "*")))
(use-package popweb
  :init
  (my/add-extra-folder-to-load-path "popweb" '("extension/dict" "extension/latex" "extension/org-roam" "extension/url-preview"))
  :commands (popweb-dict-bing-pointer
             popweb-dict-bing-input
             popweb-dict-youdao-pointer
             popweb-latex-mode
             popweb-dict-youglish-pointer
             popweb-dict-youglish-input
             popweb-dict-dictcn-pointer
             popweb-dict-dictcn-input
             popweb-org-roam-link-show
             popweb-org-roam-link-preview-select
             popweb-org-roam-node-preview-select
             popweb-url-input
             popweb-url-preview-pointer)
  :bind (("C-c s d b" . popweb-dict-bing-pointer)
         ("C-c s d y" . popweb-dict-youdao-pointer))
  ;; :demand t
  ;; :hook ((org-mode latex-mode) . popweb-latex-mode)
  :config
  (require 'popweb-dict)
  (require 'popweb-url)
  (require 'popweb-latex)
  (require 'popweb-org-roam-link)
  (setq popweb-zoom-factor 0.5)
  (setq popweb-python-command my/epc-python-command))

(setq popweb-python-command my/epc-python-command)

(my/straight-if-use '(websocket-bridge :type git :host github :repo "ginqi7/websocket-bridge"))
(use-package websocket-bridge
  :defer t)

(my/straight-if-use '(dictionary-overlay :type git :host github :repo "ginqi7/dictionary-overlay" :files ("*")))
(use-package dictionary-overlay
  :commands (dictionary-overlay-start
             dictionary-overlay-mark-word-unknown
             dictionary-overlay-mark-word-known
             dictionary-overlay-render-buffer
             my/dictionary-overlay-toggle
             my/dictionary-overlay-render-buffer
             my/dictionary-overlay-mark-word-unknown
             my/dictionary-overlay-mark-word-known)
  :config
  (setq dictionary-overlay-user-data-directory (expand-file-name "dictionary-overlay-data" no-littering-var-directory))

  (defun my/dictionary-overlay-render-buffer ()
    "render buffer, if backend is not start, start it first"
    (interactive)
    (unless dictionary-overlay-active-p
      (unless (featurep 'dictionary-overlay)
        (require 'dictionary-overlay))
      (dictionary-overlay-start)
      (dictionary-overlay-render-buffer)))
  (defun my/dictionary-overlay-toggle ()
    (interactive)
    (if dictionary-overlay-active-p
        (dictionary-overlay-toggle)
      (my/dictionary-overlay-render-buffer)))

  (defun my/dictionary-overlay-mark-word-unknown ()
    "mark word unknow, if backend is not start, start it first"
    (interactive)
    (my/dictionary-overlay-render-buffer)
    (dictionary-overlay-mark-word-unknown))

  (defun my/dictionary-overlay-mark-word-known ()
    "mark word know, if backend is not start, start it first"
    (interactive)
    (my/dictionary-overlay-render-buffer)
    (dictionary-overlay-mark-word-known))
  )

;; (autoload 'dictionary-overlay-start "dictionary-overlay" nil t)
;; (autoload 'dictionary-overlay-render-buffer "dictionary-overlay" nil t)

(my/straight-if-use '(baidu-translate :type git :host github :repo "suxiaogang223/baidu-translate"))
(use-package baidu-translate
  :commands (baidu-translate-en-mark
             baidu-translate-zh-mark
             baidu-translate-en-whole-buffer
             baidu-translate-zh-whole-buffer)
  :config
  ;;需要去百度申请API
  ;;设置你的百度翻译APPID
  ;; (setq baidu-translate-appid "your APPID")
  ;;设置你的秘钥
  ;; (setq baidu-translate-security "your SECURITY")
  (load-file "~/org/private/baidu.el"))


(provide 'init-dictionary)
