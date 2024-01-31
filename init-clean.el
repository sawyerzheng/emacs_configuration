;; -*- coding: utf-8; -*-

(provide 'init-clean)


(let (;; temporarily increase `gc-cons-threshold' when loading to speed up startup.
      (gc-cons-threshold most-positive-fixnum)
      ;; Empty to avoid analyzing files when loading remote files.
      (file-name-handler-alist nil))

  ;; Emacs configuration file content is written below.

  ;; set load path
  (add-to-list 'load-path "~/.conf.d" t)
  (add-to-list 'load-path "~/.conf.d/extra.d/" t)
  ;; (require 'init-benchmark-init)
  ;; (require 'init-esup)
  (global-unset-key (kbd "C-h r"))
  (defun my/reload-init-file () (interactive) (load-file user-init-file))
  (global-set-key (kbd "C-h r r") #'my/reload-init-file)

  (require 'init-load-tools)
  (require 'init-lib-regexp)
  (require 'init-proxy)
  (require 'init-straight)


  (global-set-key (kbd "C-h r f") #'my-straight-make-sure-freeze-packages)

  (unless (directory-empty-p (expand-file-name "straight/build/use-package" user-emacs-directory))
    (add-to-list 'load-path (expand-file-name "straight/build/use-package" user-emacs-directory) t))

  (require 'init-use-package)
  (require 'init-no-littering)
  (require 'init-compat) ;; for compatibility
  (require 'major-mode-hydra)
  (require 'init-logging)

  (setq max-lisp-eval-depth 1000000)

  ;; * 垃圾站
  (setq delete-by-moving-to-trash t)


  ;; compile(build) in parallel
  (use-package comp
    :config
    (defcustom native-compile-async-jobs
      (or (ignore-errors
	    (string-to-number (shell-command-to-string "nproc")))
	  1)
      "How many jobs to use."
      :type 'integer)

    (setf native-compile-async-jobs 8)

    (defun ap/package-native-compile-async (package &optional all)
      "Compile PACKAGE natively, or with prefix ALL, all packages."
      (interactive (list (unless current-prefix-arg
			   (completing-read "Package: " (mapcar #'car package-alist)))))
      (let* ((directory (if package
			    (file-name-directory (locate-library package))
			  package-user-dir)))
	(native-compile-async directory native-compile-async-jobs t))))

  ;; * 自动换行
  (setq truncate-lines t)

  ;; backup files
  (setq make-backup-files t)

  ;; * GUI -- toolbar, menubar, scrollbar
  (scroll-bar-mode -1)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (global-set-key (kbd "C-c t m") #'menu-bar-mode)
  (global-set-key (kbd "C-c t t") #'tool-bar-mode)
  ;; frame title
  (setq frame-title-format '(multiple-frames "%b"
					     ;; ("" "%b - Clean Emacs")
					     ("" "%b - Clean Emacs @ " system-name)))

  ;; 着重显示所在行
  (global-hl-line-mode 1)
  ;; mode-line 显示列数
  (column-number-mode 1)

  ;; * 最近历史文件
  (require 'init-recentf)


  ;; * 自动刷新文件
  (global-auto-revert-mode 1)

  ;; * sub-word
  (global-subword-mode +1)

  ;; * 显示时间
  ;; display with 24 hour format
  (setq display-time-24hr-format t)
  (display-time-mode 1)

  ;; * 退出 emacs 前，弹出提示
  (setq confirm-kill-emacs 'y-or-n-p)

  ;; * 切换默认浏览器工具
  (use-package browse-url
    :bind ("C-c t W" . my/switch-default-browser)
    ;; :bind ("C-c t W" . (lambda () (interactive) (customize-set-variable 'browse-url-browser-function 'variable-interactive)))
    :config
    (when my/windows-p
      (setq browse-url-chrome-program "chrome.exe"))

    ;; (setq browse-url-browser-function #'browse-url-default-browser)
    )

  ;; * language 语言环境设置
  (global-set-key (kbd "C-c t l") #'set-language-environment)
  (set-language-environment 'UTF-8)

  ;; (set-language-environment 'Chinese-GB)
  ;; default-buffer-file-coding-system变量在emacs23.2之后已被废弃，使用buffer-file-coding-system代替
  (set-default buffer-file-coding-system 'utf-8-unix)
  (set-default-coding-systems 'utf-8-unix)
  (setq-default pathname-coding-system 'utf-8)
  (setq file-name-coding-system 'utf-8)
  (prefer-coding-system 'cp950)
  (prefer-coding-system 'gb2312)
  (prefer-coding-system 'cp936)
  (prefer-coding-system 'gb18030)
  (prefer-coding-system 'utf-16)
  (prefer-coding-system 'utf-8-dos)
  (prefer-coding-system 'utf-8-unix)



  ;; * 默认shell
  (when my/windows-p
    (setq explicit-shell-file-name "pwsh")
    (setq default-process-coding-system '(gb18030 . utf-8-dos))
    ;; (setq default-process-coding-system '(utf-8-dos . utf-8-unix))
    )



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
    :init
    ;; (setq save-place-file (expand-file-name "file-cursor-places" my/etc-dir))
    (setq save-place-forget-unreadable-files nil)
    :hook (my/startup . save-place-mode)
    :config
    )

  ;; * UI 设置
  (require 'init-ui)
  (require 'init-window)
  (require 'init-winum)
  (require 'init-ace-window)
  (require 'init-resize-window)
  (require 'init-line-number)
  (require 'init-all-the-icons)
  (require 'init-page-break-lines)
  (require 'init-dashboard)

  (require 'init-project)
  ;; (require 'init-projectile)
  (require 'init-vertico)
  (require 'init-consult)
  (require 'init-embark)
  (require 'init-corfu)
  (require 'init-yasnippet)
  (require 'init-thing-edit)
  (require 'init-one-key)
  (if my/use-xah-fly-keys
      (straight-use-package 'which-key)
    (require 'init-which-key))

  (require 'init-unicode-fonts)
  (require 'init-folding)

  ;; tree-sitter
  (if (>= emacs-major-version 29)
      (require 'init-treesit)
    (require 'init-tree-sitter))


  ;; scroll
  (require 'init-smartparens)

  ;; lsp
  (require 'init-lsp-bridge)
  (require 'init-anaconda-mode)
  (require 'init-lsp-toggle)
  ;; lsp-bridge not support windows and terminal document
  ;; (if (or (not (display-graphic-p)))
  ;;     (my-enable-eglot)
  ;;   (my-enable-lsp-bridge))

  ;; debug
  (require 'init-dap-mode)
  (require 'init-realgud)

  ;; space and indent
  (require 'init-indent-tabs)
  (require 'init-pangu-spacing)
  (require 'init-ws-butler)
  (require 'init-whitespace-show)

  ;; org mode
  (require 'init-valign)
  (require 'init-org)
  (require 'init-org-roam)

  (require 'init-nov)

  ;; prog
  (require 'init-highlight-indent-guides)
  ;; python
  (require 'init-python)
  (require 'init-ein)
  ;; c and cpp
  (require 'init-c)

  ;; rust
  (require 'init-rust)

  ;; elisp
  (require 'init-emacs-lisp)

  ;; chinese input
  (require 'init-pyim)
  (when (<= emacs-major-version 29)
    (require 'init-liberime))
  (require 'init-sis)

  ;; keys
  (require 'init-god-mode)
  (require 'init-evil)


  ;; font and theme
  (require 'init-font)
  (require 'init-theme)
  (require 'init-ansi-color)

  ;; tools
  (require 'init-lookup)
  (require 'init-docsets)
  (require 'init-dictionary)
  (require 'init-treemacs)
  (require 'init-multiple-cursors)
  (require 'init-pdf-tools)
  (require 'init-everything)
  (require 'init-eshell)
  (require 'init-shell)

  ;; workspace
  (require 'init-persp-mode)
  ;; (add-hook 'my/startup-hook #'(lambda () ))


  ;; markdown
  (require 'init-markdown)

  ;; dired
  (require 'init-dired)
  (require 'init-file-tools)
  (require 'init-openfile)
  (require 'init-news)

  ;; git
  (require 'init-git)

  ;; major modes
  (require 'init-major-modes)
  (require 'init-csv)

  ;; file templates
  ;; (require 'init-yatemplate)
  (require 'init-file-templates)

  (require 'init-expand-region)

  (require 'init-jump)

  (require 'init-auto-save)

  (require 'init-plantuml-mode)
  (require 'init-regexp)

  (require 'init-auto-sudoedit)
  ;; (require 'init-better-jumper)

  (require 'init-quickrun)
  (require 'init-format)

  ;; (when (and
  ;;        ;; my/linux-p
  ;;        (display-graphic-p))
  ;;   (require 'init-eaf))
  (require 'init-eaf)

  (require 'init-align)
  (require 'init-xref)
  (require 'init-ligature)

  (require 'init-elfeed)
  (require 'init-undo)
  (require 'init-deno)
  ;; (require 'init-cns)
  (require 'init-chinese-word-segment)
  (require 'init-calfw)

  (require 'init-tramp)
  (require 'init-security)


  (require 'init-auto-complete)
  (require 'init-company)

  (require 'init-search)
  (require 'init-sql)

  ;; (require 'init-mail)
  ;; (require 'init-matrix-chat)
  ;; (require 'init-backup-file)
  (require 'init-openai)
  (require 'init-ai-code)

  (require 'init-exec-path-from-shell)


  ;; * write org-mode comments
  ;; (require 'init-poporg)
  (require 'init-separedit)

  (require 'init-web)
  (require 'init-meow-edit)

  (require 'init-command-log)

  (require 'init-so-long)

  (require 'init-mwim)

  (require 'init-server)
  ;; ;; ;; xah-fly-keys ------ start at earlier time
  (require 'init-xah-fly-keys)

  (add-hook 'lisp-interaction-mode #'lsp-bridge-mode)
  ;; (switch-to-buffer "*scratch*")

  )



(when (equal emacs-major-version 29)
  (setq max-specpdl-size 500
        max-lisp-eval-depth 300))
