(provide 'init-docsets)


;; zeal
(require 'init-zeal)

;; devdocs
(defun my/devdocs-set-local-docsets ()
  (let* ((defaults (cdr (assq major-mode my/devdocs-major-mode-docs-alist))))
    (setq-local devdocs-current-docs defaults)))

(my/straight-if-use 'devdocs)
(use-package devdocs
  :commands (devdocs-dwim
	     devdocs-install)
  :bind (:map prog-mode-map
              ("M-<f1>" . devdocs-dwim))
  :hook (prog-mode . my/devdocs-set-local-docsets)
  :init
  (defvar my/devdocs-major-mode-docs-alist
    '()
    "Alist of MAJOR-MODE and list of docset names.")
  (setq my/devdocs-major-mode-docs-alist
        '((c-mode          . ("c"))
          (c++-mode        . ("cpp"))
          (python-mode     . ("python~3.9" "numpy~1.22" "pandas~1" "flask~2.2"))
          (ruby-mode       . ("ruby~3.1"))
          (go-mode         . ("Go"))
          (rustic-mode     . ("Rust"))
          (css-mode        . ("CSS"))
          (html-mode       . ("HTML"))
          ;; (js-mode         . ("javascript" "jquery" "vue~3"))
          ;; (js2-mode        . ("JavaScript" "JQuery"))
          (emacs-lisp-mode . ("Elisp"))
          (cmake-mode . ("CMake"))))



  ;; (mapc
  ;;  (lambda (e)
  ;;    (add-hook (intern (format "%s-hook" (car e)))
  ;;              (lambda ()
  ;;                (setq-local devdocs-current-docs (cdr e)))))
  ;;  devdocs-major-mode-docs-alist)

  ;; (setq devdocs-data-dir (expand-file-name "devdocs" user-emacs-directory))

  (defun devdocs-dwim ()
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

     (alist-get major-mode my/devdocs-major-mode-docs-alist)
     )

    ;; Lookup the symbol at point
    (devdocs-lookup nil (thing-at-point 'symbol t)))

  )

(my/straight-if-use 'counsel-dash)
(use-package counsel-dash
  :commands (counsel-dash-at-point
             counsel-dash-install-docset))



;; use consult + dash-docs
(my/straight-if-use 'consult-dash)
(use-package consult-dash
  ;; :straight (:type git :type codeberg :repo "ravi/consult-dash")
  :commands (consult-dash)
  :config
  ;; Use the symbol at point as initial search term
  (consult-customize consult-dash :initial (thing-at-point 'symbol))
  (require 'dash-docs))



;; config for `dash-docs'
(defvar dash-docs-docsets nil
    "docs for this buffer")

  (defvar my/dash-docs-local-not-installed nil
    "not installed docset preconfigured for buffer")

  (defvar my/dash-docs-default-docsets
    '(
      (c-mode          . ("C"))
      (c-ts-mode          . ("C"))
      (c++-mode        . ("C++"))
      (c++-ts-mode        . ("C++"))
      (python-mode     . ("Python_2" "Python_3" "Pandas" "NumPy" "OpenCV_Python"))
      (python-ts-mode     . ("Python_2" "Python_3" "Pandas" "NumPy" "OpenCV_Python"))
      (ruby-mode       . ("Ruby"))
      (go-mode         . ("Go"))
      (go-ts-mode         . ("Go"))
      (rustic-mode     . ("Rust"))
      (css-mode        . ("CSS"))
      (html-mode       . ("HTML"))
      (js-mode         . ("JavaScript" "JQuery"))
      (js2-mode        . ("JavaScript" "JQuery"))
      (emacs-lisp-mode . ("Emacs_Lisp"))
      (cmake-mode . ("CMake"))
      (rust-mode . ("Rust"))
      (rust-ts-mode . ("Rust"))
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
      )
    (my/dash-docs-set-local-docsets))

  (defun my/dash-docs-installed-p (docset)
    (let* ((download-name (replace-regexp-in-string " " "_" docset))
           (doc-path (expand-file-name (concat (if my/windows-p
                                                   download-name
                                                 docset)
                                               ".docset")
                                       dash-docs-docsets-path)))
      (file-exists-p doc-path)))

  (defun my/counsel-dash-at-point ()
    "auto install docsets before search documentation"
    (interactive)
    (my/dash-docs-set-local-docsets)
    (my/dash-docs-install-missing)
    (counsel-dash-at-point))



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

(my/straight-if-use 'dash-docs)
(use-package dash-docs
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
  (unless (file-exists-p dash-docs-docsets-path)
    (make-directory dash-docs-docsets-path 'parents))
  

  
  :hook (prog-mode . (lambda () 
                       (require 'dash-docs)
                       (my/dash-docs-set-local-docsets)))
  :commands (my/counsel-dash-at-point))

(my/straight-if-use 'ivy)
(use-package ivy
  :bind (:map ivy-minibuffer-map
              ("M-n" . ivy-next-line)
              ("M-p" . ivy-previous-line)))
