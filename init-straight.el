;; -*- coding: utf-8; -*-
(if (>= (string-to-number emacs-version) 27)
    (setq package-enable-at-startup nil))


;; for pin before start `straight'
(setq straight-profiles
      '((nil . "default.el")
        ;; Packages which are pinned to a specific commit.
        (pinned . "pinned.el")))
;; * bootstrap just when straight not installed


(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; options
(when (functionp 'native-compile)
  (progn
    (add-to-list 'native-comp-eln-load-path (concat user-emacs-directory ".cache/eln/"))
    (setq package-native-compile t)
    (setq straight-disable-native-compile nil)))

;; (setq straight-vc-git-default-clone-depth 1)

;; for pin after start straight
(autoload #'straight-x-pull-all "straight-x")
(autoload #'straight-x-freeze-versions "straight-x")
(autoload #'straight-x-freeze-pinned-versions "straight-x")
(autoload #'straight-x-thaw-pinned-versions "straight-x")
;;--------------------------------- end of straight itself ---------------

;; * when to check(straight-use-package)
;; (setq straight-check-for-modifications '(check-on-save))
;; (setq straight-check-for-modifications nil)
;; ------------------------------------------------------------------------
(defun my-straight-pin (cons-cell)
  (add-to-list 'straight-x-pinned-packages cons-cell))

;; * declare pinned packages
(defun my-straight-make-sure-freeze-packages ()
  "freeze pinned and thaw pinned again, to make sure using pinned packages"
  (interactive)


  (let ((straight-current-profile 'pinned))

    ;; Pin org-mode version.
    (my-straight-pin '("conda" . "78e1aad076f6cefc6aa7cc77d08e174b13050994"))
    (my-straight-pin
     ;; '("lsp-bridge" . "137ba780623f88c2911694c0a26e357631e2dab6")
     ;; '("lsp-bridge" . "c3dea2a16b8aec4e22fc9e3ffc62ee40d3c905e6")
     ;; '("lsp-bridge" . "5dc54efc85ce4188664b539c40ff0f22188efe65")
     '("lsp-bridge" . "ddfe463cf6ed2dc5c8528b18529a55ea0174b71f")
     )
    (my-straight-pin '("xah-fly-keys" . "5347be6e3165c74d9edc2a84010c2099f0620388"))
    (my-straight-pin '("pyim" .
                       ;; "6b4cea1b541f5efd18067d4cafa1ca4b059a0c63"
                       "35315cf9fd554bb652961e5a8a8ebbafc3566d2e"
                       ))
    (my-straight-pin '("lispy" . "df1b7e614fb0f73646755343e8892ddda310f427")))
  (straight-x-freeze-pinned-versions)
  (straight-x-thaw-pinned-versions))

(global-set-key (kbd "C-h r f") #'my-straight-make-sure-freeze-packages)
;; --------------------------------------------------------------------------
;; ;; * packages to install
;; (straight-use-package 'use-package)
;; (straight-use-package 'general)
;; (straight-use-package 'quelpa)
;; (straight-use-package 'delight)

;; ;; * for use-package

;; ;; evil
;; (straight-use-package 'evil)
;; (straight-use-package 'evil-escape)
;; (straight-use-package 'evil-args)
;; (straight-use-package 'evil-nerd-commenter)
;; (straight-use-package 'evil-snipe)
;; (straight-use-package 'evil-surround)
;; (straight-use-package 'evil-lion)

;; ;; fold
;; (straight-use-package 'origami)
;; (straight-use-package 'yafolding)

;; ;; key
;; (straight-use-package 'god-mode)
;; ;; ---- for key binding


;; ;; completion
;; (straight-use-package 'company)

;; (straight-use-package 'embark)
;; (straight-use-package 'marginalia)
;; (straight-use-package 'embark-consult)

;; (straight-use-package 'vertico)
;; (straight-use-package 'consult)
;; (straight-use-package 'tempel)
;; (straight-use-package 'corfu)
;; (straight-use-package 'corfu-doc)
;; (add-to-list 'load-path "~/.conf.d/extra.d/emacs-corfu-terminal/")
;; (straight-use-package
;;  '(popon :type git :repo "https://codeberg.org/akib/emacs-popon.git"))
;; (straight-use-package
;;  '(corfu-terminal
;;    :type git
;;    :repo "https://codeberg.org/akib/emacs-corfu-terminal.git"))
;; (straight-use-package 'cape)
;; (straight-use-package 'orderless)
;; (straight-use-package 'kind-icon)
;; (straight-use-package 'yasnippet)
;; (straight-use-package 'yasnippet-snippets)


;; ;; gui
;; (straight-use-package 'posframe)
;; (straight-use-package 'all-the-icons)
;; (straight-use-package 'unicode-fonts)
;; (straight-use-package 'winum)
;; (straight-use-package 'ace-window)
;; (straight-use-package 'resize-window)
;; (straight-use-package 'which-key)
;; (straight-use-package 'doom-themes)
;; (straight-use-package 'doom-modeline)
;; (straight-use-package 'nav-flash)

;; ;; jump
;; (straight-use-package 'smartparens)

;; ;; check
;; (straight-use-package 'flycheck)

;; ;; tree-sitter
;; (straight-use-package 'tree-sitter)
;; (straight-use-package 'tree-sitter-langs)

;; ;; elisp
;; (straight-use-package 'elisp-def)
;; (straight-use-package 'elisp-demos)
;; (straight-use-package 'highlight-quoted)
;; (straight-use-package '(lispy :files (:defaults "*")))

;; ;;git
;; (straight-use-package 'magit)
;; (straight-use-package 'dired-k)
;; (straight-use-package 'treemacs-icons-dired)
;; (straight-use-package 'all-the-icons-dired)
;; (straight-use-package 'dired-sidebar)
;; (straight-use-package '(dirvish :files (:defaults "extensions")))
;; (straight-use-package 'diredfl)

;; ;; tools
;; (straight-use-package 'conda)
;; (straight-use-package 'projectile)
;; (straight-use-package 'magit)
;; (straight-use-package 'benchmark-init)
;; (straight-use-package 'ace-jump-mode)
;; (straight-use-package 'simpleclip)
;; (straight-use-package 'youdao-dictionary)
;; (straight-use-package 'fanyi)
;; (straight-use-package 'treemacs)
;; (straight-use-package 'treemacs-evil)
;; (straight-use-package 'treemacs-projectile)
;; (straight-use-package 'treemacs-magit)
;; (straight-use-package 'counsel-jq)
;; (straight-use-package 'multiple-cursors)
;; (straight-use-package '(pdf-tools :files (:defaults "*")))

;; ;; indent
;; (straight-use-package 'dtrt-indent)
;; (straight-use-package 'pangu-spacing)
;; (straight-use-package 'valign)

;; ;; org
;; ;; (unless (eq system-type 'windows-nt)
;; ;;   (straight-use-package 'org-mode))

;; (straight-use-package 'org-cliplink)
;; (straight-use-package 'org-download)
;; (straight-use-package 'org-superstar)
;; (straight-use-package 'org-rich-yank)
;; (straight-use-package 'org-fancy-priorities)
;; ;; org ox, export
;; (straight-use-package 'ox-pandoc)

;; ;; markdown
;; (straight-use-package 'markdown-mode)
;; (straight-use-package 'edit-indirect)
;; (straight-use-package 'markdown-preview-mode)
;; (straight-use-package 'impatient-mode)
;; (straight-use-package 'grip-mode)
;; (straight-use-package 'vmd-mode)
;; (straight-use-package '(markdown-dnd-images :type git :host github :repo "mooreryan/markdown-dnd-images"))

;; ;; json
;; (straight-use-package 'json-mode)

;; ;; input
;; (straight-use-package `(liberime
;;                         :pre-build ,(pcase system-type
;;                                       (`gnu/linux '("make"))
;;                                       (`widnows-nt '(message "liberime can not be made on windows"))
;;                                       ;; (_ '("make"))
;;                                       )))
;; (straight-use-package '(liberime
;;                         :post-build ("make")))
;; (straight-use-package 'pyim)
;; (straight-use-package 'popup)
;; (straight-use-package 'pyim-basedict)


;; ;; lsp
;; (straight-use-package '(lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge" :files ("*")))
;; (straight-use-package 'lsp-mode)
;; (straight-use-package 'lsp-pyright)
;; (straight-use-package 'lsp-java)

;; ;; python
;; ;; (straight-use-package '(simple-httpd :local-repo "simple-httpd"))
;; (straight-use-package 'jupyter)
;; (straight-use-package 'live-py-mode)

;; ;; powershell
;; (straight-use-package 'powershell)

;; ;; major-modes
;; (straight-use-package 'cmake-mode)
;; (straight-use-package 'yaml-mode)
;; (straight-use-package 'web-mode)
;; (straight-use-package 'js2-mode)
;; (straight-use-package 'lua-mode)

;; ;; workspace
;; (straight-use-package 'perspective)

(provide 'init-straight)
