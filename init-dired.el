;; -*- coding: utf-8; -*-
;;;###autoload
(defun my/open-file-externally (&optional arg)
  "open current file in dired or current corresponding file in file buffer
 with external tools."
  (interactive "P")
  (let* ((file (cond ((eq major-mode 'dired-mode)
                      (dired-get-file-for-visit))
                     ((buffer-file-name) (buffer-file-name))
                     (t "")))
         (ext (f-ext file))
         ($thing nil))
    (when (and arg (functionp #'eaf-open))
      (eaf-open file))

    (cond
     ((eq major-mode 'org-mode)
      (org-open-at-point))
     ;; url at point
     ((thing-at-point 'url)
      (let* (($url (thing-at-point 'url)))
        (if (and (not (eq browse-url-browser-function 'eaf-open-browser))
                 my/wsl-p
                 (string-match-p "^https?://" $url))
            (shell-command (format "cmd.exe /c start %s" $url))
          (browse-url $url))))
     ((thing-at-point 'filename)
      ;; file at point
      (let* (($file (thing-at-point 'filename)))
        ;; make sure valid file path
        (if (and (string-match "/\\|\\\\\\|~" $file) (string-match "^\\(\\w:/\\)\\|~\\|/" $file))
            (cond
             ((string-match "#" $file)
              (let (($fpath (substring $file 0 (match-beginning 0)))
                    ($fractPart (substring $file (1+ (match-beginning 0)))))
                (if (file-exists-p $fpath)
                    (progn
                      (find-file $fpath)
                      (goto-char (point-min))
                      (search-forward $fractPart))
                  (when (y-or-n-p (format "file does not exist: [%s]. Create?" $fpath))
                    (find-file $fpath)))))
             ((null (file-name-extension $file))
              (if my/wsl-p
                  (shell-command-to-string (format "code %s" $file))
                (consult-file-externally $file)))
             (t
              (if my/wsl-p
                  (shell-command-to-string (format "powershell.exe -noprofile  -noninteractive -windowstyle hidden \" ii $(wslpath -w %s)\"" $file))
                (consult-file-externally $file))))
          (message "Not valid file path at point: %s \nopen buffer file instead" $file)
          (if my/wsl-p
              (shell-command-to-string (format "powershell.exe -noprofile  -noninteractive -windowstyle hidden \" ii $(wslpath -w %s)\"" file))
            (consult-file-externally file)))))

     (t
      ;; other place, open the buffer file
      (if my/wsl-p
          (shell-command-to-string (format "powershell.exe -noprofile  -noninteractive -windowstyle hidden \" ii $(wslpath -w %s)\"" file))
        (consult-file-externally file))))))

(my/straight-if-use '(dired :type built-in))
(my/straight-if-use '(nerd-icons-dired :type git :host github :repo "rainstormstudio/nerd-icons-dired"))
(my/straight-if-use 'diredfl)
(my/straight-if-use '(dired-x :type built-in))
(my/straight-if-use 'dired-k)

(use-package dired
  :init
  ;; for sort file byt time name size
  (defun xah-dired-sort ()
    "Sort dired dir listing in different ways.
Prompt for a choice.
URL `http://ergoemacs.org/emacs/dired_sort.html'
Version 2018-12-23"
    (interactive)
    (let ($sort-by $arg)
      (setq $sort-by (ido-completing-read "Sort by:" '("date" "size" "name")))
      (cond
       ((equal $sort-by "name") (setq $arg "-Al "))
       ((equal $sort-by "date") (setq $arg "-Al -t"))
       ((equal $sort-by "size") (setq $arg "-Al -S"))
       ;; ((equal $sort-by "dir") (setq $arg "-Al --group-directories-first"))
       (t (error "logic error 09535")))
      (dired-sort-other $arg)))
  ;; keybinding for local dired
  (defun xah-show-in-desktop ()
    "Show current file in desktop.
 (Mac Finder, Windows Explorer, Linux file manager)
 This command can be called when in a file or in `dired'.

URL `http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2018-09-29"
    (interactive)
    (let (($path (if (buffer-file-name) (buffer-file-name) default-directory)))
      (cond
       ((string-equal system-type "windows-nt")
        (w32-shell-execute "explore" (replace-regexp-in-string "/" "\\" $path t t)))
       ((string-equal system-type "darwin")
        (if (eq major-mode 'dired-mode)
            (let (($files (dired-get-marked-files)))
              (if (eq (length $files) 0)
                  (progn
                    (shell-command
                     (concat "open " default-directory)))
                (progn
                  (shell-command
                   (concat "open -R " (shell-quote-argument (car (dired-get-marked-files))))))))
          (shell-command
           (concat "open -R " $path))))
       ((string-equal system-type "gnu/linux")
        (let (
              (process-connection-type nil)
              (openFileProgram (if (file-exists-p "/usr/bin/gvfs-open")
                                   "/usr/bin/gvfs-open"
                                 "/usr/bin/xdg-open")))
          (start-process "" nil openFileProgram $path))
        ;; (shell-command "xdg-open .") ;; 2013-02-10 this sometimes froze emacs till the folder is closed. eg with nautilus
        ))))

  ;; ============= size
  (defun dired-get-size ()
    (interactive)
    (let ((files (dired-get-marked-files)))
      (with-temp-buffer
        ;; (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
        (apply 'call-process "du" nil t nil "-sch" files)
        (message "Size of all marked files: %s"
                 (progn
                   (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
                   (match-string 1))))))
  :bind
  (:map dired-mode-map
        ("s" . xah-dired-sort)
        ("?" . dired-get-size))
  :config
  (setq dired-listing-switches "-alh")
  :init

  :bind (:map dired-mode-map
              ("e" . my/open-file-externally))

  :config
  ;; * extra packages
  ;; (use-package dired-x ;; WARNING: this will make dired slow
  ;;   :after dired
  ;;   :hook (dired-mode . dired-omit-mode))

  (use-package dired-k
    :after dired
    :hook (dired-mode . dired-k)
    :bind (:map dired-mode-map
                ("g" . dired-k))
    :config
    (setq dired-k-style 'git)
    (setq dired-k-human-readable t))
  (use-package nerd-icons-dired
    :hook (dired-mode . nerd-icons-dired-mode))


  (use-package diredfl
    :hook (dired-mode . diredfl-mode)))

;; (my/straight-if-use '(dirvish :files (:defaults "extensions")))
;; (use-package dirvish
;;   :after dired
;;   :init
;;   (my/add-extra-folder-to-load-path "dirvish" '("extensions"))

;;   :commands (dirvish-mode dirvish-dispatch dirvish-fd)
;;   :hook (my/startup . (lambda () (with-eval-after-load 'dired
;;                                    (dirvish-override-dired-mode))))
;;   :bind (:map dirvish-mode-map
;;               ("P" . dirvish-dispatch))
;;   :config
;;   (setq dirvish-hide-details t)
;;   (require 'dirvish-bookmark)
;;   (require 'dirvish-extras)
;;   (require 'dirvish-fd)
;;   (require 'dirvish-history)
;;   (require 'dirvish-icons)
;;   (require 'dirvish-menu)
;;   (require 'dirvish-peek)
;;   (require 'dirvish-side)
;;   (require 'dirvish-subtree)
;;   (require 'dirvish-vc))

(use-package dired-sidebar
  :commands (dired-sidebar-show-sidebar
             dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  (setq dired-sidebar-subtree-line-prefix "  ")
  (defun my/dired-sidebar--fold-subtree ()
    (interactive)
    (when (dired-subtree--is-expanded-p)
      (dired-next-line 1)
      (dired-subtree-remove)
      ;; #175 fixes the case of the first line in dired when the
      ;; cursor jumps to the header in dired rather then to the
      ;; first file in buffer
      (when (bobp)
        (dired-next-line 1))))
  (defun my/dired-sidebar--expand-subtree ()
    (interactive)
    (unless (dired-subtree--is-expanded-p)
      (save-excursion (dired-subtree-insert))))
  :bind (:map dired-sidebar-mode-map
	      ("h" . my/dired-sidebar--fold-subtree)
	      ("l" . my/dired-sidebar--expand-subtree))
  :config
  (advice-add 'my/dired-sidebar--expand-subtree
              :around 'dired-sidebar-omit-after-dired-subtree-cycle)
  (advice-add 'my/dired-sidebar--fold-subtree
              :around 'dired-sidebar-omit-after-dired-subtree-cycle)

  (advice-add 'my/dired-sidebar--expand-subtree :around #'nerd-icons-dired--refresh-advice)
  (advice-add 'my/dired-sidebar--fold-subtree :around #'nerd-icons-dired--refresh-advice)

  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-theme 'nerd-icons)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

(use-package ztree
  :commands (ztree-dir
             ztree-diff)
  :bind (:map ztree-mode-map
              ("p" . ztree-previous-line)
              ("n" . ztree-next-line)))

(my/straight-if-use '(dired-rsync :type git :host github :repo "stsquad/dired-rsync"))
(use-package dired-rsync
  :after dired
  :bind (:map dired-mode-map
              ("C-c C-r" . dired-rsync)
              ("r r" . dired-rsync)))

(use-package dired-rsync-transient

  :bind (:map dired-mode-map
              ("C-c C-x" . dired-rsync-transient)
              ("r x" . dired-rsync-transient)))

(provide 'init-dired)
