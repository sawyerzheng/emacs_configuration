;; -*- coding: utf-8; -*-
(use-package dired
  :straight (:type built-in)
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
  (defun my/open-file-externally ()
    "open current file in dired or current corresponding file in file buffer
 with external tools."
    (interactive)
    (let* ((file (cond ((eq major-mode 'dired-mode)
                        (dired-get-file-for-visit))
                       ((buffer-file-name) (buffer-file-name))
                       (t "")))
           (ext (f-ext file)))
      (consult-file-externally file)))

  :bind (:map dired-mode-map
              ("e" . my/open-file-externally))
  :bind ("C-c o E" . my/open-file-externally)

  :config
  ;; * extra packages
  (use-package dired-x
    :straight (:type built-in)
    :after dired
    :hook (dired-mode . dired-omit-mode))

  (use-package dired-k
    :straight t
    :after dired
    :hook (dired-mode . dired-k)
    :bind (:map dired-mode-map
                ("g" . dired-k))
    :config
    (setq dired-k-style 'git)
    (setq dired-k-human-readable t))
  (use-package all-the-icons-dired
    :straight t
    :after dired
    :hook (dired-mode . all-the-icons-dired-mode)
    :config
    ;; (remove-hook 'dired-mode-hook 'treemacs-icons-dired-mode)
    )
  (use-package diredfl
    :straight t
    :hook (dired-mode . diredfl-mode)))








;; (use-package treemacs-icons-dired
;;   :straight t
;;   :hook (dired-mode . treemacs-icons-dired-mode))

(use-package dirvish
  :after dired
  :straight (dirvish :files (:defaults "extensions"))
  :init
  (my-add-extra-folder-to-load-path "dirvish" '("extensions"))

  :commands (dirvish-mode dirvish-dispatch dirvish-fd)
  :hook (after-init . (lambda () (with-eval-after-load 'dired
                                   (dirvish-override-dired-mode))))
  :bind (:map dirvish-mode-map
              ("P" . dirvish-dispatch))
  :config
  (setq dirvish-hide-details t)
  (require 'dirvish-bookmark)
  (require 'dirvish-extras)
  (require 'dirvish-fd)
  (require 'dirvish-history)
  (require 'dirvish-icons)
  (require 'dirvish-menu)
  (require 'dirvish-peek)
  (require 'dirvish-side)
  (require 'dirvish-subtree)
  (require 'dirvish-vc))

(provide 'init-dired)
