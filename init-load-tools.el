;;; load-tools.emacs -*- lexical-binding: t; coding: utf-8; -*-
;;
;; Copyright (C) 2022 Sawyer Zheng
;;
;; Author: Sawyer Zheng <kmxsz@qq.com>
;; Maintainer: Sawyer Zheng <kmxsz@qq.com>
;; Created: 六月 02, 2022
;; Modified: 六月 02, 2022
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/sawyer/load-tools
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;
;;
;;; Code:

(defvar my/4k-p
  (ignore-errors (>= (x-display-pixel-height) 2160))
  "if monitor is a 4k screen.")
(defvar my/windows-p
  (eq system-type 'windows-nt))

(defvar my/linux-p
  (eq system-type 'gnu/linux))

(defvar my/linux-vm-p
  (eq 0 (call-process-shell-command "grep -q \"^flags.*\ hypervisor\ \"  /proc/cpuinfo")))

(defvar my/terminal-p
  (not (display-graphic-p)))

(defvar my/graphic-p
  (display-graphic-p))


(defvar my/wsl-p
  (file-exists-p "/usr/bin/wslpath"))

(defun my/get-linux-distro ()
  "from lsb_release"
  (interactive)
  (when (eq system-type 'gnu/linux)
    (let* ((raw-str (shell-command-to-string "lsb_release -sd")))
      (car (split-string raw-str "\"" t "\"")))))

(defvar my/arch-p
  (equal (my/get-linux-distro) "Arch Linux"))


(defvar my/etc-dir
  (expand-file-name ".local/etc/" user-emacs-directory)
  "path to put package configurations.")
;; `my/etc-dir' create if not exist
(unless (file-exists-p my/etc-dir)
  (make-directory my/etc-dir t))

(defvar my/cache-dir
  (expand-file-name ".local/cache/" user-emacs-directory))

(defvar my/auto-restore-workspace
  nil
  "whether or not to save and load workspace at starting and quitting emacs")

(setq my/program-dir
      (cond ((eq system-type 'windows-nt) "d:/programs/")
            (t "~/programs/")))

(setq my/program-extra-dir
      (cond ((eq system-type 'windows-nt) "e:/programs/")
            (t my/program-dir)))

(defvar my/use-xah-fly-keys t)

(defun my-add-extra-folder-to-load-path (root-lib extra-folders)
  "add direct subfolders in `libary' root folder to `load-path'"
  (let* ((lib-root (file-name-directory (locate-library root-lib)))
         (one-load-folder))
    (dolist (one-load-folder extra-folders)
      (when one-load-folder
        (add-to-list 'load-path (expand-file-name one-load-folder lib-root))))))


(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
  (back-to-indentation)
  )
(global-set-key (kbd "M-Y") #'duplicate-line)

(defun my/get-project-root ()
  "use different tools to find project root"
  (cond ((boundp 'elpy-project-root)
         (elpy-project-root))
        ((boundp 'projectile-mode)
         (require 'projectile)
         (projectile-project-root))
        ((project-current)
         (project-root (project-current)))
        (t
         (vc-root-dir))))

(defun my-toggle-visual-line ()
  (interactive)
  (if global-visual-line-mode
      (global-visual-line-mode -1)
    (global-visual-line-mode +1)))

(global-set-key (kbd "C-c t w") #'my-toggle-visual-line)

(defun setq-hook (hook var val)
  (add-hook 'hook #'(lambda () (setq-local var val))))



;;; load-tools.emacs ends here



;; (let* ((app-folder (expand-file-name "app" eaf-path-prefix))
;;        (apps (apply (lambda (f-candi) (expand-file-name f-candi app-folder))
;;                     (apply (lambda (f) (if (not (member f '("." ".."))))) app-folder)))
;;        (valid-apps ())))

;; (dolist (folder (directory-files (expand-file-name "app" eaf-path-prefix)))
;;   (unless (member folder '("." ".."))
;;     (setq (expand-file-name folder eaf-path))))

;; copy from lazycat emacs
(require 'cl-lib)
(defun add-subdirs-to-load-path (search-dir)
  (interactive)
  (let* ((dir (file-name-as-directory search-dir)))
    (dolist (subdir
             ;; 过滤出不必要的目录，提升Emacs启动速度
             (cl-remove-if
              #'(lambda (subdir)
                  (or
                   ;; 不是文件的都移除
                   (not (file-directory-p (concat dir subdir)))
                   ;; 目录匹配下面规则的都移除
                   (member subdir '("." ".." ;Linux当前目录和父目录
                                    "dist" "node_modules" "__pycache__" ;语言相关的模块目录
                                    "RCS" "CVS" "rcs" "cvs" ".git" ".github")))) ;版本控制目录
              (directory-files dir)))
      (let ((subdir-path (concat dir (file-name-as-directory subdir))))
        ;; 目录下有 .el .so .dll 文件的路径才添加到 `load-path' 中，提升Emacs启动速度
        (when (cl-some #'(lambda (subdir-file)
                           (and (file-regular-p (concat subdir-path subdir-file))
                                ;; .so .dll 文件指非Elisp语言编写的Emacs动态库
                                (member (file-name-extension subdir-file) '("el" "so" "dll"))))
                       (directory-files subdir-path))

          ;; 注意：`add-to-list' 函数的第三个参数必须为 t ，表示加到列表末尾
          ;; 这样Emacs会从父目录到子目录的顺序搜索Elisp插件，顺序反过来会导致Emacs无法正常启动
          (add-to-list 'load-path subdir-path t))

        ;; 继续递归搜索子目录
        (add-subdirs-to-load-path subdir-path)))))


(defun my/load-eaf ()
  "load eaf configuration"
  (interactive)
  (require 'init-eaf))

(defun my/local-keymap ()
  "automatically get major mode local keymap, eg: `emacs-lisp-mode-local-keymap' "
  (let* ((local-keymap (intern (concat (symbol-name major-mode) "-local-keymap"))))
    (if (boundp 'local-keymap)
        local-keymap
      nil)))

(defvar my/conf-distro-dir (file-name-directory load-file-name) 
  "folder to place most init files")

(defvar my/extra.d-dir (expand-file-name "extra.d" my/conf-distro-dir)
  "folder to my manualy downloaded elisp packages")

(defvar my/arch-p (equal (my/get-linux-distro) "Arch Linux")
  "is arch linux distrobution")

(provide 'init-load-tools)
