(provide 'init-docsets)

;; (use-package devdocs
;;   :bind (:map prog-mode-map
;;               ("M-<f1>" . devdocs-dwim))
;;   :init
;;   (defvar devdocs-major-mode-docs-alist
;;     '((c-mode          . ("C"))
;;       (c++-mode        . ("C++"))
;;       (python-mode     . ("Python 3.9" "Python 3.8"))
;;       (ruby-mode       . ("Ruby 3"))
;;       (go-mode         . ("Go"))
;;       (rustic-mode     . ("Rust"))
;;       (css-mode        . ("CSS"))
;;       (html-mode       . ("HTML"))
;;       (js-mode         . ("JavaScript" "JQuery"))
;;       (js2-mode        . ("JavaScript" "JQuery"))
;;       (emacs-lisp-mode . ("Elisp"))
;;       (cmake-mode . ("CMake")))
;;     "Alist of MAJOR-MODE and list of docset names.")

;;   (mapc
;;    (lambda (e)
;;      (add-hook (intern (format "%s-hook" (car e)))
;;                (lambda ()
;;                  (setq-local devdocs-current-docs (cdr e)))))
;;    devdocs-major-mode-docs-alist)

;;   (setq devdocs-data-dir (expand-file-name "devdocs" user-emacs-directory))
;;   (defun devdocs-dwim()
;;     "Look up a DevDocs documentation entry.
;; Install the doc if it's not installed."
;;     (interactive)
;;     ;; Install the doc if it's not installed
;;     (mapc
;;      (lambda (str)
;;        (let* ((docs (split-string str " "))
;;               (doc (if (length= docs 1)
;;                        (downcase (car docs))
;;                      (concat (downcase (car docs)) "~" (downcase (cdr docs))))))
;;          (unless (and (file-directory-p devdocs-data-dir)
;;                       (directory-files devdocs-data-dir nil "^[^.]"))
;;            (message "Installing %s..." str)
;;            (devdocs-install doc))))
;;      (alist-get major-mode devdocs-major-mode-docs-alist))

;;     ;; Lookup the symbol at point
;;     (devdocs-lookup nil (thing-at-point 'symbol t))))

;; (use-package counsel-dash
;;   :straight t
;;   :commands (counsel-dash-at-point
;;              counsel-dash-install-docset))



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
  ;;* global
  ;;  =dash-docs-common-docsets=
  ;;* buffer-local
  ;;  =dash-docs-docsets=

  ;; mkdir -p ~/.docsets to suppress error
  (make-directory dash-docs-docsets-path t)

  (defvar my/dash-docs-local-not-installed nil
    "not installed docset preconfigured for buffer")
  (defvar my/dash-docs-default-docsets
    '((python-mode . ("Python_3" "Numpy" "Pandas"))
      (cmake-mode . ("CMake"))
      (c-mode . ("C"))
      (c++-mode . ("C" "C++" "Boost")))
    "default docsets for respective major mode")

  (defvar-local my/dash-docs-local-not-installed nil
    "local docsets(set as default) not installed")

  (defun my/dash-docs-set-local-docsets ()
    (let* ((defaults (cdr (assq major-mode my/dash-docs-default-docsets)))
           (installed-docsets (remove-if-not #'dash-docs-docset-installed-p defaults))
           (not-installed-docsets (remove-if #'dash-docs-docset-installed-p defaults)))
      (setq-local dash-docs-docsets installed-docsets)
      (when (functionp 'consult-dash)
        (setq-local consult-dash-docsets installed-docsets))
      (setq-local my/dash-docs-local-not-installed not-installed-docsets)))
  (defun my/dash-docs-install-missing ()
    "automatically and asyc install missing docsets"
    (interactive)
    (dolist (elem my/dash-docs-local-not-installed)
      (dash-docs-install-docset elem)))
  :hook (prog-mode . my/dash-docs-set-local-docsets))
