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
  (>= (x-display-pixel-height) 2160)
  "if monitor is a 4k screen.")
(defvar my/windows-p
  (eq system-type 'windows-nt))

(defvar my/linux-p
  (eq system-type 'gnu/linux))

(defvar my/linux-vm-p
  (eq 0 (call-process-shell-command "grep -q \"^flags.*\ hypervisor\ \"  /proc/cpuinfo")))

(defvar my/wsl-p
  (file-exists-p "/usr/bin/wslpath"))

(defvar my/etc-dir
  (expand-file-name ".local/etc/" user-emacs-directory)
  "path to put package configurations.")
;; `my/etc-dir' create if not exist
(unless (file-exists-p my/etc-dir)
  (make-directory my/etc-dir t))

(defvar my/auto-restore-workspace
  t
  "whether or not to save and load workspace at starting and quitting emacs")

(setq my/program-dir
      (cond ((eq system-type 'windows-nt) "d:/programs/")
            (t "~/programs/")))

(setq my/program-extra-dir
        (cond ((eq system-type 'windows-nt) "e:/programs/")
              (t my/program-dir)))

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

(provide 'init-load-tools)
