;; -*- coding: utf-8; -*-
(if (eq system-type 'windows-nt)
    (progn (setq eaf-path-prefix "d:/programs/eaf/")
           (setq eaf-python-command "d:/soft/miniconda3/envs/tools/python.exe"))
  (progn (setq eaf-path-prefix "~/programs/eaf/")
         (setq eaf-python-command "~/miniconda3/envs/tools/bin/python")))
(add-to-list 'load-path eaf-path-prefix)
(add-subdirs-to-load-path eaf-path-prefix)
;; ---------------------- my automatic load apps ------------------
;; (require 'eaf)

;; (defun my:eaf-make-load-path (plugin)
;;   (concat eaf-path-prefix "app/" plugin "/")
;;   )

;; ;; want to initialize applications
;; (setq my:eaf-applications '("browser" "pdf-viewer" "camera" "terminal" "video"))
;; (setq my:eaf-applications '("airshare" "browser" "camera" "demo" "file-browser" "file-manager" "file-sender" "image-viewer" "jupyter" "markdown-previewer" "mindmap" "music-player" "netease-cloud-music" "org-previewer" "pdf-viewer" "rss-reader" "system-monitor" "terminal" "video-player" "vue-demo"))
;; ;; no elisp applications: ("mermaid" )


;; ;; add load path for applications
;; (mapcar (lambda (plugin) (add-to-list 'load-path (my:eaf-make-load-path plugin)))
;;  my:eaf-applications)

;; ;; make feature names
;; (setq my:eaf-applications-feature-names
;;	  (mapcar (lambda (app) (concat "eaf-" app))
;;			  my:eaf-applications))
;; ;; load applications as features
;; (mapcar (lambda (feature-name)
;;		  (require (intern feature-name)))
;;		my:eaf-applications-feature-names)
;;---------------- end my automatic load apps ----------------------------
(use-package eaf
  :init
  (defun eaf-open-this-buffer ()
    (interactive)
    (eaf-open (buffer-file-name (current-buffer))))

  :commands (eaf-open eaf-open-browser
                      eaf-open-jupyter
                      eaf-open-rss-reader
                      eaf-open-terminal
                      eaf-open-system-monitor
                      eaf-file-browser-qrcode
                      eaf-file-sender-qrcode
                      eaf-file-sender-qrcode-in-dired
                      eaf-open-airshare
                      eaf-open-browser-with-history)
  ;; :bind (("C-c o e b" . eaf-open-browser-with-history)
  ;;        ("C-c o e B" . eaf-open-bookmark)
  ;;        ("C-c o e s" . eaf-search-it)
  ;;        ("C-c s w" . eaf-search-it)

  ;;        ("C-c b b" . eaf-open-browser-with-history)
  ;;        ("C-c b B" . eaf-open-browser)
  ;;        ("C-c b o" . eaf-open)
  ;;        ("C-c b s" . eaf-search-it)
  ;;        ("C-c b t" . eaf-open-terminal)
  ;;        )
  :custom
                                        ; See https://github.com/emacs-eaf/emacs-application-framework/wiki/Customization
  (eaf-browser-continue-where-left-off t)
  (eaf-browser-enable-adblocker t)
  (browse-url-browser-function 'eaf-open-browser)
  (eaf-pdf-dark-mode nil)
  (eaf-browser-dark-mode "follow")
  (eaf-file-manager-dark-mode nil)
  (eaf-org-previewer-dark-mode nil)
  (eaf-terminal-dark-mode nil)
  (eaf-jupyter-dark-mode nil)
  :config
  (require 'eaf-vue-demo)
  (require 'eaf-browser)
  (require 'eaf-netease-cloud-music)
  (require 'eaf-markdown-previewer)
  (require 'eaf-pdf-viewer)
  (require 'eaf-org-previewer)
  (require 'eaf-jupyter)
  (require 'eaf-file-manager)
  ;; (require 'eaf-rss-reader)
  (require 'eaf-terminal)
  (require 'eaf-system-monitor)
  (require 'eaf-file-browser)
  (require 'eaf-file-sender)
  (require 'eaf-airshare)
  (use-package eaf-music-player
    :load-path (lambda () (expand-file-name (concat eaf-path-prefix "app/music-player"))))
  (require 'eaf-music-player)
  ;; (defalias 'browse-web #'eaf-open-browser)
  (with-eval-after-load 'eaf-pdf-viewer
    (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
    (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding))
  (with-eval-after-load 'eaf-browser
    (eaf-bind-key ace-window "M-o" eaf-browser-keybinding))
  ;; (eaf-bind-key take_photo "p" eaf-camera-keybinding)
  (eaf-bind-key nil "M-q" eaf-browser-keybinding)








  ;; unbind, see more in the Wiki

  (defun eaf-toggle-browser-dark-mode ()
    (interactive)
    (if (eq eaf-browser-dark-mode nil)
        (setq eaf-browser-dark-mode "follow")
      (setq eaf-browser-dark-mode nil)))



  ;; copy from lazycat emacs
  (require 'eaf)
  (require 'eaf-browser)
  (require 'eaf-pdf-viewer)
  (require 'eaf-markdown-previewer)
  (require 'eaf-video-player)
  (require 'eaf-image-viewer)
  (require 'eaf-org-previewer)
  (require 'eaf-mindmap)
  (require 'eaf-mail)
  (require 'eaf-terminal)
  (require 'eaf-camera)
  (require 'eaf-jupyter)
  (require 'eaf-netease-cloud-music)
  (require 'eaf-music-player)
  (require 'eaf-system-monitor)
  (require 'eaf-file-manager)
  (require 'eaf-file-browser)
  (require 'eaf-demo)
  (require 'eaf-vue-demo)
  ;; (require 'eaf-rss-reader)
  (require 'eaf-git)

  (require 'popweb)


;;; Code:

  ;; You need configuration your own local proxy program first.
  ;; (setq eaf-proxy-type "socks5")
  ;; (setq eaf-proxy-host "127.0.0.1")
  ;; (setq eaf-proxy-port "1080")

  ;; Make `eaf-browser-restore-buffers' restore last close browser buffers.
  (setq eaf-browser-continue-where-left-off t)

  (eaf-bind-key undo_action "C-/" eaf-browser-keybinding)
  (eaf-bind-key redo_action "C-?" eaf-browser-keybinding)
  (eaf-bind-key scroll_up "M-j" eaf-browser-keybinding)
  (eaf-bind-key scroll_down "M-k" eaf-browser-keybinding)
  (eaf-bind-key scroll_up_page "M-n" eaf-browser-keybinding)
  (eaf-bind-key scroll_down_page "M-p" eaf-browser-keybinding)
  (eaf-bind-key open_link "M-h" eaf-browser-keybinding)
  (eaf-bind-key open_link_new_buffer "M-H" eaf-browser-keybinding)
  (eaf-bind-key insert_or_open_link_new_buffer "D" eaf-browser-keybinding)
  (eaf-bind-key insert_or_open_link_background_buffer "F" eaf-browser-keybinding)
  (eaf-bind-key watch-other-window-up-line "M-<" eaf-browser-keybinding)
  (eaf-bind-key watch-other-window-down-line "M->" eaf-browser-keybinding)
  (eaf-bind-key emacs-session-save "<f5>" eaf-browser-keybinding)
  (eaf-bind-key refresh_page "M-r" eaf-browser-keybinding)
  (setq eaf-webengine-default-zoom
        (if my/4k-p
            1.7
          1.0))
  ;; (setq eaf-webengine-default-zoom (if (> (frame-pixel-width) 3000) 2 1))
  (setq eaf-browser-aria2-proxy-host "127.0.0.1")
  (setq eaf-browser-aria2-proxy-port "7890")
  (setq eaf-browser-enable-adblocker t)
  (setq eaf-browser-enable-autofill t)
  (setq eaf-music-play-order "random")
  (setq eaf-marker-letters "JKHLNMUIOYPFDSAVCRREW")
  (setq eaf-terminal-font-size 18)
  (setq eaf-webengine-font-family "WenQuanYi Micro Hei Mono")
  (setq eaf-webengine-fixed-font-family "WenQuanYi Micro Hei Mono")
  (setq eaf-webengine-serif-font-family "TsangerJinKai03-6763")
  (setq eaf-webengine-font-size 18)
  (setq eaf-webengine-fixed-font-size 18)
  (setq eaf-terminal-font-family "WenQuanYi Micro Hei Mono")
  (setq eaf-jupyter-font-family "WenQuanYi Micro Hei Mono")
  (setq eaf-file-manager-show-hidden-file nil)
  (setq eaf-music-default-file "/data/Music/")

  (defun jekyll-start-server ()
    (interactive)
    (eaf-terminal-run-command-in-dir "jekyll serve --livereload" "/home/andy/manateelazycat.github.io"))

  (defun jekyll-open-local ()
    (interactive)
    (eaf-open-browser "http://127.0.0.1:4000"))

  (defun eaf-goto-left-tab ()
    (interactive)
    (sort-tab-select-prev-tab))

  (defun eaf-goto-right-tab ()
    (interactive)
    (sort-tab-select-next-tab))

  (defun eaf-translate-text (text)
    (popweb-dict-bing-input text))

  (use-package sort-tab
    :straight (sort-tab :type git :host github :repo "manateelazycat/sort-tab")
    :config
    ;; (sort-tab-mode +1)
    )

  (use-package one-key
    :straight (one-key :type git :host github :repo "manateelazycat/one-key"))
  (one-key-create-menu
   "GIT"
   '(
     (("s" . "Git status") . eaf-open-git)
     (("u" . "Git push to remote") . eaf-git-push)
     (("i" . "Git pull") . eaf-git-pull)
     (("c" . "Git clone") . eaf-git-clone)
     (("h" . "Git history") . eaf-git-show-history))
   t))

(provide 'init-eaf)
