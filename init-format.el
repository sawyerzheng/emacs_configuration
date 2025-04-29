(provide 'init-format)

(defvar my/use-format-all-p nil)

(my/straight-if-use 'format-all)
(use-package format-all
  ;; :if my/use-format-all-p
  :commands (format-all-mode
             format-all-buffer
             format-all-region
             format-all-ensure-formatter)
  :init
  (defvar my/format-all-default-formatters
    '(("Python" black)
      ("C++" clang-format)
      ("C" clang-format)
      ("JSON" prettierd)
      ("Emacs Lisp" emacs-lisp))
    "default formatter for buffer local settings")
  (defun my/format-all-set-formatters-fn ()
    ;; (setq format-all-formatters (alist-get major-mode my/format-all-default-formatters))
    (setq-local format-all-formatters my/format-all-default-formatters)

    )
  ;; :hook ((c++-mode c-mode) . format-all-mode)
  :hook ((format-all-mode
	  python-mode
          c++-mode
          c-mode
          json-mode
          markdown-mode
          gfm-mode java-mode) . my/format-all-set-formatters-fn))


;;; apheleia

;;;; 依赖

;; uv tool install black
;; uv
;; npm i -g prettier
;; npm install -g @taplo/cli

(my/straight-if-use 'apheleia)
(use-package apheleia
  :unless my/use-format-all-p
  :commands
  (apheleia-mode
   apheleia-global-mode
   apheleia-format-buffer)
  :config
  (add-to-list 'exec-path (expand-file-name "scripts/formatters" (file-name-parent-directory (locate-library "apheleia"))))

  (setf (alist-get 'taplo apheleia-formatters)
        '("taplo" "fmt" "-"))
  (setf (alist-get 'toml-ts-mode apheleia-mode-alist)
        'taplo)
  (setf (alist-get 'conf-toml-mode apheleia-mode-alist)
        'taplo)

  ;; npm i -D prettier prettier-plugin-sh
  ;; ref: https://www.npmjs.com/package/prettier-plugin-sh?activeTab=readme
  (add-to-list 'apheleia-formatters
	       '(prettier-dockerfile
		 . ("npx" "prettier" "--stdin-filepath" filepath
		    "--plugin=prettier-plugin-sh" "--parser=Dockerfile"
		    )))
  (add-to-list 'apheleia-formatters
	       '(prettier-gitignore
		 . ("npx" "prettier" "--stdin-filepath" filepath
		    "--plugin=prettier-plugin-sh"
		    )))
  )


(defun my/format-buffer-fn (&optional args)
    "format all buffer, tend to use `apheleia-format-buffer' instead of `format-all-buffer'"
    (interactive)
    (cond
     ((derived-mode-p 'js2-mode)
      (apheleia-format-buffer 'prettier-javascript))
     ((derived-mode-p 'css-mode 'css-ts-mode)
      (apheleia-format-buffer 'prettier-css))
     ((derived-mode-p 'html-mode 'html-ts-mode)
      (apheleia-format-buffer 'prettier-html))
     ((derived-mode-p 'web-mode)
      (apheleia-format-buffer 'prettier-html))
     ((derived-mode-p 'python-mode 'python-ts-mode)
      (apheleia-format-buffer 'black))
     ((derived-mode-p 'markdown-mode)
      (apheleia-format-buffer 'prettier-markdown))
     ((derived-mode-p 'c-mode 'c++-mode 'c-ts-mode 'c++-ts-mode)
      (apheleia-format-buffer 'clang-format))
     ((derived-mode-p 'json-mode 'json-ts-mode)
      (apheleia-format-buffer 'prettier-json))
     ((derived-mode-p 'rust-mode 'rust-ts-mode)
      (apheleia-format-buffer 'rustfmt))
     ((derived-mode-p 'toml-ts-mode 'conf-toml-mode)
      (apheleia-format-buffer 'taplo))
     ((derived-mode-p 'prog-mode)
      (call-interactively #'format-all-buffer))
     (t
      (ignore-errors
	(funcall-interactively #'xah-reformat-lines)))))
