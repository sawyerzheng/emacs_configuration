;; -*- coding: utf-8; -*-
;; set load path
(add-to-list 'load-path "~/.conf.d")
(add-to-list 'load-path "~/.conf.d/extra.d/")
(require 'init-benchmark-init)
;; (require 'init-esup)
(global-unset-key (kbd "C-h r"))
(defun my/reload-init-file () (interactive) (load-file user-init-file))
(global-set-key (kbd "C-h r r") #'my/reload-init-file)

(require 'init-proxy)
(require 'init-straight)
(unless (directory-empty-p (expand-file-name "straight/build/use-package" user-emacs-directory))
  (add-to-list 'load-path (expand-file-name "straight/build/use-package" user-emacs-directory)))

(require 'init-use-package)
(require 'init-logging)

(setq max-lisp-eval-depth 1000000)

;; * 垃圾站
(setq delete-by-moving-to-trash t)

;; * 自动换行
(setq truncate-lines t)

;; * GUI -- toolbar, menubar, scrollbar
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-set-key (kbd "C-c t m") #'menu-bar-mode)
;; 着重显示所在行
(global-hl-line-mode +1)
;; mode-line 显示列数
(column-number-mode +1)

;; * 最近历史文件
(setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
(recentf-mode +1)

;; * 自动刷新文件
(global-auto-revert-mode +1)

;; * 显示时间
;; display with 24 hour format
(setq display-time-24hr-format t)
(display-time-mode +1)

;; * 切换默认浏览器工具
(use-package browse-url
  :init
  (defun my/switch-default-browser ()
    (interactive)
    (let ((select-choise)
          (function-assoc '(("default" . browse-url-default-browser)
                            ("eaf" . eaf-open-browser)
                            ("w3m" . w3m-browse-url)
                            ("eww" . eww-browse-url)
                            ("firefox" . browse-url-firefox)
                            ("chrome" . browse-url-chrome))))
      (setq select-choise (ido-completing-read "Choose Browser:" '("default" "eaf" "w3m" "eww" "firefox" "chrome")))
      (setq browse-url-browser-function (cdr (assoc select-choise function-assoc)))
      ))
  :bind ("C-c t W" . my/switch-default-browser)
  :config
  ;; (setq browse-url-browser-function #'browse-url-default-browser)
  )

;; * language 语言环境设置
(global-set-key (kbd "C-c t l") #'set-language-environment)
(set-language-environment 'UTF-8)

;; xah-fly-keys ------ start at earlier time
(require 'init-xah-fly-keys)


;; * 杂项
;; (toggle-debug-on-quit +1)
;; for terminal fix
;; (unless (display-graphic-p)
;;   (global-set-key (kbd "C-x ;") #'comment-line))
(global-set-key (kbd "C-x ;") #'comment-line)
;; disable `Alt + Tab'
(global-unset-key (kbd "M-<tab>"))

;; * 保存退出光标位置
;; remember cursor position
(use-package saveplace
  :hook (after-init . save-place-mode)
  :config
  (setq save-place-file (expand-file-name ".local/file-cursor-places" my/etc-dir)))

(require 'init-load-tools)

(require 'init-window)
(require 'init-winum)
(require 'init-ace-window)
(require 'init-resize-window)
(require 'init-line-number)
(require 'init-doom-modeline)
(require 'init-all-the-icons)
(require 'init-page-break-lines)
(require 'init-dashboard)

(require 'init-projectile)
(require 'init-vertico)
(require 'init-consult)
(require 'init-embark)
(require 'init-corfu)
(require 'init-yasnippet)
(require 'init-which-key)
(require 'init-unicode-fonts)

;; tree-sitter
(require 'init-tree-sitter)
;; * write org-mode comments
(require 'init-poporg)

;; scroll
(require 'init-smartparens)

;; lsp
(require 'init-lsp-bridge)
(require 'init-lsp-toggle)
;; lsp-bridge not support windows and terminal document
(if (or (not (display-graphic-p)))
    (my-enable-lsp-mode)
  (my-enable-lsp-bridge))


;; space and indent
(require 'init-indent-tabs)
(require 'init-pangu-spacing)
(require 'init-ws-butler)

;; org mode
(require 'init-valign)
(require 'init-org)

;; python
(require 'init-python-basic)
(require 'init-conda)
(require 'init-yafolding)
(require 'init-live-py-plugin)


;; elisp
(require 'init-emacs-lisp)

;; chinese input
(require 'init-pyim)
(require 'init-liberime)

;; keys
(require 'init-god-mode)
(require 'init-evil)


;; font and theme
(require 'init-font-and-theme)
(require 'init-ansi-color)

;; tools
(require 'init-lookup)
(require 'init-dictionary)
(require 'init-treemacs)
(require 'init-multiple-cursors)
(require 'init-pdf-tools)
(require 'init-everything)

;; workspace
(require 'init-persp-mode)
;; (add-hook 'after-init-hook #'(lambda () ))


;; markdown
(require 'init-markdown)

;; dired
(require 'init-dired)
(require 'init-file-tools)
(require 'init-openfile)

;; git
(require 'init-git)

;; major modes
(require 'init-major-modes)



(provide 'init-clean)
