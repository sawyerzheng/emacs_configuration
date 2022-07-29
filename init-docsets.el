(provide 'init-docsets)

;; zeal
(require 'init-zeal)

;; devdocs
(use-package devdocs
  :straight t
  :bind (:map prog-mode-map
              ("M-<f1>" . devdocs-dwim))
  :hook (prog-mode . my/devdocs-set-local-docsets)
  :init
  (defvar my/devdocs-major-mode-docs-alist
    '((c-mode          . ("c"))
      (c++-mode        . ("cpp"))
      (python-mode     . ("python~3.9" "numpy~1.22" "pandas~1"))
      (ruby-mode       . ("ruby~3.1"))
      (go-mode         . ("Go"))
      (rustic-mode     . ("Rust"))
      (css-mode        . ("CSS"))
      (html-mode       . ("HTML"))
      (js-mode         . ("JavaScript" "JQuery"))
      (js2-mode        . ("JavaScript" "JQuery"))
      (emacs-lisp-mode . ("Elisp"))
      (cmake-mode . ("CMake")))
    "Alist of MAJOR-MODE and list of docset names.")

  (defun my/devdocs-set-local-docsets ()
    (let* ((defaults (cdr (assq major-mode my/devdocs-major-mode-docs-alist))))
      (setq-local devdocs-current-docs defaults)))

  ;; (mapc
  ;;  (lambda (e)
  ;;    (add-hook (intern (format "%s-hook" (car e)))
  ;;              (lambda ()
  ;;                (setq-local devdocs-current-docs (cdr e)))))
  ;;  devdocs-major-mode-docs-alist)

  (setq devdocs-data-dir (expand-file-name "devdocs" user-emacs-directory))

  (defun devdocs-dwim()
    "Look up a DevDocs documentation entry.
Install the doc if it's not installed."
    (interactive)
    ;; Install the doc if it's not installed
    (mapc
     (lambda (str)
       (let* ((docs (split-string str " "))
              (doc (if (length= docs 1)
                       (downcase (car docs))
                     (concat (downcase (car docs)) "~" (downcase (car (cdr docs)))))))

         (unless (and (file-directory-p (expand-file-name doc devdocs-data-dir))
                      (directory-files devdocs-data-dir nil "^[^.]"))
           (message "Installing %s..." str)

           (devdocs-install
            (cdr (assoc doc
                        (mapcar (lambda (it) (cons (alist-get 'slug it) it))
                                (devdocs--available-docs))))))))

     (alist-get major-mode my/devdocs-major-mode-docs-alist))

    ;; Lookup the symbol at point
    (devdocs-lookup nil (thing-at-point 'symbol t)))

  )

(use-package counsel-dash
  :straight t
  :commands (counsel-dash-at-point
             counsel-dash-install-docset))



;; use consult + dash-docs

(use-package consult-dash
  :straight (:type git :repo "https://codeberg.org/ravi/consult-dash.git")
  :commands (consult-dash)
  :config
  ;; Use the symbol at point as initial search term
  (consult-customize consult-dash :initial (thing-at-point 'symbol)))

(use-package dash-docs
  :straight t
  :commands (dash-docs-install-docset)
  :config
  ;; * debug
  (setq dash-docs-enable-debugging nil)
  ;; * docsets store path

  (setq dash-docs-docsets-path
        (cond (my/windows-p
               "e:/soft/zeal/docsets/")
              (my/linux-p
               "~/.local/share/Zeal/Zeal/docsets/")
              (t
               "~/.docsets")))


  ;;* global
  ;;  =dash-docs-common-docsets=
  ;;* buffer-local
  ;;  =dash-docs-docsets=

  ;; mkdir -p ~/.docsets to suppress error
  (make-directory dash-docs-docsets-path t)

  (defvar dash-docs-docsets nil
    "docs for this buffer")

  (defvar my/dash-docs-local-not-installed nil
    "not installed docset preconfigured for buffer")

  (defvar my/dash-docs-default-docsets
    '((python-mode . ("Python 3" "NumPy" "Pandas"))
      (cmake-mode . ("CMake"))
      (c-mode . ("C"))
      (c++-mode . ("C" "C++" "Boost"))
      ;; no docsets for elisp
      (emacs-lisp-mode . ("Emacs Lisp"))

      )
    "default docsets for respective major mode")

  (defvar-local my/dash-docs-local-not-installed nil
    "local docsets(set as default) not installed")

  (defun my/dash-docs-set-local-docsets ()
    (let* ((defaults (cdr (assq major-mode my/dash-docs-default-docsets)))
           (installed-docsets (remove-if-not #'my/dash-docs-installed-p defaults))
           (not-installed-docsets (remove-if #'my/dash-docs-installed-p defaults)))
      (setq-local dash-docs-docsets installed-docsets)
      (setq-local zeal-at-point-docset defaults)
      (setq-local consult-dash-docsets installed-docsets)
      (setq-local counsel-dash-docsets installed-docsets)

      (setq-local my/dash-docs-local-not-installed not-installed-docsets)))

  (defun my/dash-docs-install-missing ()
    "automatically and asyc install missing docsets"
    (interactive)

    (dolist (elem my/dash-docs-local-not-installed)
      (let* ((download-name (replace-regexp-in-string " " "_" elem))
             (doc-path (expand-file-name (concat elem ".docset") dash-docs-docsets-path)))
        (unless (file-exists-p doc-path))
        (dash-docs-install-docset download-name))
      ))

  (defun my/dash-docs-installed-p (docset)
    (let* ((download-name (replace-regexp-in-string " " "_" docset))
           (doc-path (expand-file-name (concat (if my/windows-p
                                                   download-name
                                                 docset)
                                               ".docset")
                                       dash-docs-docsets-path)))
      (file-exists-p doc-path)))



  ;; * fix error on windows
  (defun my/dash-docs-open-file-url (url &optional arg buffer)
    (async-shell-command
     ;; (concat "start " url)
     ;; (format "chrome.exe \"%s\" "  url)
     (format "start msedge \"%s\" "  url)
     ))

  (when my/windows-p
    (setq dash-docs-browser-func 'my/dash-docs-open-file-url))


  (defun my/dash-docs-use-default-browser ()
    (interactive)
    (setq dash-docs-browser-func 'browse-url))
  :hook (prog-mode . my/dash-docs-set-local-docsets))
