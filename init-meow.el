
(provide 'init-meow)

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
(require 'init-use-package)

(global-set-key (kbd "C-h r f") #'my-straight-make-sure-freeze-packages)


(let (;; temporarily increase `gc-cons-threshold' when loading to speed up startup.
      (gc-cons-threshold most-positive-fixnum)
      ;; Empty to avoid analyzing files when loading remote files.
      (file-name-handler-alist nil))

  ;; Emacs configuration file content is written below.


  ;; (unless (directory-empty-p (expand-file-name "straight/build/use-package" user-emacs-directory))
  ;;   (add-to-list 'load-path (expand-file-name "straight/build/use-package" user-emacs-directory) t))



  (require 'init-no-littering)
  (require 'major-mode-hydra)
  (require 'init-logging)

  (setq max-lisp-eval-depth 1000000)

  ;; * 垃圾站
  (setq delete-by-moving-to-trash t)

  ;; * 自动换行
  (setq truncate-lines t)

  ;; backup files
  (setq make-backup-files t)

  ;; * GUI -- toolbar, menubar, scrollbar
  (scroll-bar-mode -1)
  (menu-bar-mode +1)
  (tool-bar-mode -1)
  (global-set-key (kbd "C-c t m") #'menu-bar-mode)
  (global-set-key (kbd "C-c t t") #'tool-bar-mode)
  ;; frame title
  (setq frame-title-format '(multiple-frames "%b"
					     ("" "%b - Clean Emacs")))

  ;; 着重显示所在行
  (global-hl-line-mode 1)
  ;; mode-line 显示列数
  (column-number-mode 1)

  ;; * 最近历史文件
  (use-package recentf
    :config
    (if (file-exists-p recentf-save-file)
        (setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
      )
    (setq recentf-max-saved-items 1000)
    (add-to-list 'recentf-exclude  ".gpg\\'")
    (recentf-mode 1))


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



  ;; * language 语言环境设置
  (global-set-key (kbd "C-c t l") #'set-language-environment)
  (set-language-environment 'UTF-8)

  ;; * 默认shell
  (when my/windows-p
    (setq explicit-shell-file-name "pwsh"))



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

  (use-package meow
    :straight t)

  (require 'init-font)
  (require 'init-theme)
  (require 'init-vertico)
  (require 'init-corfu)
  (require 'init-embark)
  (require 'init-doom-modeline) 
  (require 'init-window)
  (require 'init-key-chord)
  (require 'init-helpful)
  (require 'init-thing-edit)
  (require 'init-which-key)
  (require 'init-persp-mode)
  (require 'init-emacs-lisp)
  (require 'init-dictionary)

  (bind-key "C-x b" #'consult-buffer)

  (which-key-mode +1)

  (key-chord-define meow-insert-state-keymap "df" #'meow-insert-exit)



  (meow-setup)
  (meow-global-mode))
