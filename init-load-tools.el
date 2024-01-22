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

(defvar my/use-head-face-scaling t
  "if use different font size for headline levels")

(defvar my/4k-p
  (ignore-errors (>= (x-display-pixel-height) 2160))
  "if monitor is a 4k screen.")
(defun my/4k-p ()
  (ignore-errors (>= (x-display-pixel-height) 2160)))

(defvar my/windows-p
  (eq system-type 'windows-nt))

(defvar my/linux-p
  (eq system-type 'gnu/linux))

(defun my/qtile-p ()
    (let* ((session (getenv "DESKTOP_SESSION")))
      (or (string= session "qtile")
	  (not (string= (shell-command-to-string "pgrep qtile") "")))))

(defvar my/linux-vm-p
  (eq 0 (call-process-shell-command "grep -q \"^flags.*\ hypervisor\ \"  /proc/cpuinfo")))

(defvar my/terminal-p
  (not (display-graphic-p)))

(defvar my/graphic-p
  (display-graphic-p))


(defvar my/wsl-p
  (file-exists-p "/usr/bin/wslpath"))

(setq my/epc-python-command (if my/windows-p
                                ;; "E:/soft/envs/win-conda/envs/tools/python"
                                "d:/soft/miniconda3/envs/tools/python.exe"
                              (expand-file-name "~/miniconda3/envs/tools/bin/python")))
(defun my/get-linux-distro ()
  "from lsb_release"
  (interactive)
  (when (eq system-type 'gnu/linux)
    (let* ((raw-str (shell-command-to-string "lsb_release -sd")))
      (car (split-string raw-str "\"" t "\"")))))

(defvar my/arch-p
  (or (equal (my/get-linux-distro) "EndeavourOS Linux")
      (equal (my/get-linux-distro) "Arch Linux")))


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

(defun my/add-extra-folder-to-load-path (root-lib extra-folders)
  "add direct subfolders in `libary' root folder to `load-path'"
  (let* ((lib-root (file-name-directory (locate-library root-lib)))
         (one-load-folder))
    (dolist (one-load-folder extra-folders)
      (when one-load-folder
        (add-to-list 'load-path (expand-file-name one-load-folder lib-root) t)))))


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
;; (global-set-key (kbd "M-Y") #'duplicate-line)

(defun my/get-project-root ()
  "use different tools to find project root"
  (cond ((boundp 'elpy-project-root)
         (elpy-project-root))
        ((and (project-current) (project-current nil (buffer-file-name)))
         (project-root (project-current)))
        ((boundp 'projectile-mode)
         (require 'projectile)
         (projectile-project-root))
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

(defun my/load-eaf-no-reload ()
  "load eaf configuration"
  (interactive)
  (unless (functionp 'eaf-open)
    (require 'init-eaf)))

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

;; ref: https://github.com/alphapapa/unpackaged.el#reload-a-packages-features
;;;###autoload
(defun unpackaged/reload-package (package &optional allp)
  "Reload PACKAGE's features.
If ALLP is non-nil (interactively, with prefix), load all of its
features; otherwise only load ones that were already loaded.

This is useful to reload a package after upgrading it.  Since a
package may provide multiple features, to reload it properly
would require either restarting Emacs or manually unloading and
reloading each loaded feature.  This automates that process.

Note that this unloads all of the package's symbols before
reloading.  Any data stored in those symbols will be lost, so if
the package would normally save that data, e.g. when a mode is
deactivated or when Emacs exits, the user should do so before
using this command."
  (interactive
   (list (intern (completing-read "Package: "
                                  (mapcar #'car package-alist) nil t))
         current-prefix-arg))
  ;; This finds features in the currently installed version of PACKAGE, so if
  ;; it provided other features in an older version, those are not unloaded.
  (when (yes-or-no-p (format "Unload all of %s's symbols and reload its features? " package))
    (let* ((package-name (symbol-name package))
           (package-dir (file-name-directory
                         (locate-file package-name load-path (get-load-suffixes))))
           (package-files (directory-files package-dir 'full (rx ".el" eos)))
           (package-features
            (cl-loop for file in package-files
                     when (with-temp-buffer
                            (insert-file-contents file)
                            (when (re-search-forward (rx bol "(provide" (1+ space)) nil t)
                              (goto-char (match-beginning 0))
                              (cadadr (read (current-buffer)))))
                     collect it)))
      (unless allp
        (setf package-features (seq-intersection package-features features)))
      (dolist (feature package-features)
        (ignore-errors
          ;; Ignore error in case it's not loaded.
          (unload-feature feature 'force)))
      (dolist (feature package-features)
        (require feature))
      (message "Reloaded: %s" (mapconcat #'symbol-name package-features " ")))))


(defun my/thing-at-point-file ()
  "find the file at point, or return `nil'."
  (let* ((file (thing-at-point 'filename))
         (file (if (null file) nil (substring-no-properties file))))
    (when (and file (file-exists-p file))
      file)))

(defun my/file-at-project-root (&optional file root)
  "if file at the root of the project"
  (let* ((file (if file file (buffer-file-name)))
         (root (if root root
                 (my/get-project-root)))
         (rel-path (cond ((or (null root) (null file))
                          nil)
                         (t
                          (file-relative-name file root))))
         (at-root (if rel-path
                      (not (string-match-p "/" rel-path)))))
    at-root))

;;;###autoload
(defun explorer (&optional path)
  "Open Finder or Windows Explorer in the current directory. If there is a filename under the cursor, open the directory part in the file explorer."
  (interactive)
  (let* ((name-at-point (my/thing-at-point-file))
         (name-at-point (cond ((null name-at-point)
                               nil)
                              ((file-directory-p name-at-point)
                               name-at-point)
                              (t
                               (file-name-directory name-at-point))))
         (folder (if (null path)
                     (if name-at-point name-at-point
                       (if (buffer-file-name)
                           (setq folder (file-name-directory (buffer-file-name)))
                         default-directory))
                   (if (file-directory-p path)
                       path
                     (if (file-exists-p path)
                         (file-name-directory path)
                       default-directory)))))
    (cond
     ((and (eq system-type 'gnu/linux) (not my/wsl-p))
      (shell-command (format "nautilus \"%s\" " (expand-file-name folder))))
     ((eq system-type 'darwin)
      (shell-command (format "open -b com.apple.finder%s"
                             (if folder (format " \"%s\""
                                                (file-name-directory
                                                 (expand-file-name folder))) ""))))
     ((or (eq system-type 'windows-nt) my/wsl-p)
      ;; (message "windows: %s" folder)
      ;; (shell-command (format "explorer.exe %s"
      ;;                        (replace-regexp-in-string
      ;;                         "/" "\\\\"
      ;;                         folder)))
      (let ((default-directory folder)
            (app (if (executable-find "explorer.exe")
                     "explorer.exe"
                   "explorer")))
        (shell-command (concat app " .")))))))


(defun my/eaf-mode-p ()
  "if in a eaf-mode or eaf derived mode"
  (derived-mode-p 'eaf-mode))

(defun my/minibuffer-mode-p ()
  (derived-mode-p 'minibuffer-mode))

(defun my/exeucte-key-macro (keys)
  (let ((inhibit-message t))
    (execute-kbd-macro (read-kbd-macro keys))))

;; ref: https://emacs.stackexchange.com/a/59607
;; wsl-copy
(defun my/wsl-copy (start end)
  (interactive "r")
  (shell-command-on-region start end "clip.exe")
  (deactivate-mark))


;; wsl-paste
(defun my/wsl--get-clipboard ()
  "get content from clipboard"
  (let ((clipboard
         (shell-command-to-string "timeout 0.7 powershell.exe -NoProfile -NonInteractive -c '$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding ; Get-Clipboard' 2> /dev/null")))
    (setq clipboard (replace-regexp-in-string (regexp-quote "") "" clipboard)) ;; Remove Windows ^M characters
    (when (not (string-empty-p clipboard))
      (setq clipboard (substring clipboard 0 -1)))
    ;; Remove newline added by Powershell
    clipboard))

(defun my/wsl-paste ()
  "insert content from windows clipboard"
  (interactive)
  (let ((clipboard (my/wsl--get-clipboard)))
    (insert clipboard)))

(defvar my/startup-hook nil
  "hook for after-init hook and server-after-make-frame-hook"
  )
(add-hook 'after-init-hook (lambda () (run-hooks 'my/startup-hook)))
(add-hook 'server-after-make-frame-hook (lambda () (run-hooks 'my/startup-hook)))

(defun my/clean-overlay ()
  "clean overlays in current buffer"
  (interactive)
  (mapcar #'delete-overlay (car (overlay-lists)))
  (mapcar #'delete-overlay (cdr (overlay-lists))))

(when my/windows-p
  (setq find-program "d:/soft/scoop/shims/find.exe"))

(when (< emacs-major-version 29)
  (cl-defgeneric project-name (project)
    "A human-readable name for the project.
Nominally unique, but not enforced."
    (file-name-nondirectory (directory-file-name (project-root project))))

  (cl-defmethod project-name ((project (head vc)))
    (or (project--value-in-dir 'project-vc-name (project-root project))
        (cl-call-next-method))))


;; file name auto expand
(defun my/buffer-file-name-adv-fn (&optional buffer)
  "Advice function to get the absolute file path after `buffer-file-name' is called."
  (if buffer-file-name
      (setq buffer-file-name (file-truename buffer-file-name))))

;; (advice-add 'buffer-file-name :before #'my/buffer-file-name-adv-fn)
;; (advice-remove 'buffer-file-name #'my/buffer-file-name-adv-fn)

;; * quit window
(defun my/meow-quit (&optional arg)
  "Quit current window or buffer."
  (interactive "P")
  (cond
   ((derived-mode-p 'lsp-bridge-ref-mode) (lsp-bridge-ref-quit))
   (t (if arg
          (if (> (seq-length (window-list (selected-frame))) 1)
              (delete-window)
            (previous-buffer))
        (call-interactively #'quit-window)))))

;; * 切换默认浏览器工具
(defun my/switch-default-browser (&optional selected-choice)
  (interactive)

  (let ((function-assoc '(("default" . browse-url-default-browser)
                          ("eaf" . eaf-open-browser)
                          ("w3m" . w3m-browse-url)
                          ("eww" . eww-browse-url)
                          ("firefox" . browse-url-firefox)
                          ("chrome" . browse-url-chrome)
                          ("wslview" . "wslview"))))

    (unless selected-choice
      (setq selected-choice (completing-read "Choose Browser:" (mapcar 'car function-assoc))))
    (if (equal selected-choice "wslview")
        (advice-add #'browse-url :override #'my/browse-url-wsl-advice)
      (advice-remove #'browse-url #'my/browse-url-wsl-advice))
    (setq browse-url-browser-function (cdr (assoc selected-choice function-assoc)))))

(defun my/wsl-enable-wslview ()
  (interactive)
  (if my/wsl-p
      (my/switch-default-browser "wslview")))

(add-hook 'my/startup-hook #'my/wsl-enable-wslview)

;; (if (my/windows-p))
;; (add-to-list 'exec-path )
