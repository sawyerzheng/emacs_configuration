;; M-x `treesit-install-language-grammar` to install language grammar.

;; (use-package treesit
;;   :init
;;   (setq treesit-language-source-alist
;;         '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
;;           (c . ("https://github.com/tree-sitter/tree-sitter-c"))
;;           (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
;;           (css . ("https://github.com/tree-sitter/tree-sitter-css"))
;;           (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
;;           (csharp . ("https://github.com/tree-sitter/tree-sitter-c-sharp.git"))
;;           (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
;;           (elisp . ("https://github.com/Wilfred/tree-sitter-elisp"))
;;           (go . ("https://github.com/tree-sitter/tree-sitter-go"))
;;           (gomod . ("https://github.com/camdencheek/tree-sitter-go-mod.git"))
;;           (html . ("https://github.com/tree-sitter/tree-sitter-html"))
;;           (java . ("https://github.com/tree-sitter/tree-sitter-java.git"))
;;           (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
;;           (json . ("https://github.com/tree-sitter/tree-sitter-json"))
;;           (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
;;           (make . ("https://github.com/alemuller/tree-sitter-make"))
;;           (markdown . ("https://github.com/MDeiml/tree-sitter-markdown" nil "tree-sitter-markdown/src"))
;;           (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" nil "ocaml/src"))
;;           (org . ("https://github.com/milisims/tree-sitter-org"))
;;           (python . ("https://github.com/tree-sitter/tree-sitter-python"))
;;           (php . ("https://github.com/tree-sitter/tree-sitter-php"))
;;           (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
;;           (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src"))
;;           (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
;;           (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
;;           (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
;;           (vue . ("https://github.com/merico-dev/tree-sitter-vue"))
;;           (yaml . ("https://github.com/ikatyang/tree-sitter-yaml"))
;;           (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
;;           (zig . ("https://github.com/GrayJack/tree-sitter-zig"))))
;;   :config

;;   (defun my/treesit-install-language-grammer ()
;;     (interactive)
;;     (mapcar #'(lambda (grammar) (unless (treesit-language-available-p (car grammar))
;;                                   (treesit-install-language-grammar (car grammar)))) treesit-language-source-alist))
;;   (setq major-mode-remap-alist
;;         '((c-mode . c-ts-mode)
;;           (c++-mode . c++-ts-mode)
;;           (cmake-mode . cmake-ts-mode)
;;           (conf-toml-mode . toml-ts-mode)
;;           (css-mode . css-ts-mode)
;;           (js-mode . js-ts-mode)
;;           (js-json-mode . json-ts-mode)
;;           (python-mode . python-ts-mode)
;;           (sh-mode . bash-ts-mode)
;;           (typescript-mode . typescript-ts-mode)
;;           (rust-mode . rust-ts-mode)))

;;   (defun my/treesit-parser-create ()
;;     "get parser with major-mode name"
;;     (let* ((parser-alist '((emacs-lisp-mode . elisp)))
;;            (parser (cond
;;                     (;; predefined parser
;;                      ((memq major-mode (mapcar #'car parser-alist))
;;                       (cdr (assoc major-mode parser-alist))))
;;                     (;; web-mode
;;                      (eq major-mode 'web-mode)
;;                      (let ((file-name (buffer-file-name)))
;;                        (when file-name
;;                          (pcase (file-name-extension file-name)
;;                            ("vue" 'vue)
;;                            ("html" 'html)
;;                            ("php" 'php)))))
;;                     (;; default cases
;;                      t
;;                      (intern (car (string-split (symbol-name major-mode) "-")))))))
;;       (unless (ignore-errors (when parser
;;                                (treesit-parser-create parser)))
;;         (message "check parser `%s' existence" parser))))

;;   :hook ((markdown-mode . my/treesit-parser-create)
;;          (gfm-mode . (lambda () (treesit-parser-create 'markdown)))
;;          (web-mode . my/treesit-parser-create)
;;          (emacs-lisp-mode . (lambda () (treesit-parser-create 'elisp)))
;;          (ielm-mode . (lambda () (treesit-parser-create 'elisp)))
;;          (lisp-interaction-mode . (lambda () (treesit-parser-create 'elisp)))
;;          (json-mode . (lambda () (treesit-parser-create 'json)))
;;          (go-mode . (lambda () (treesit-parser-create 'go)))
;;          (java-mode . (lambda () (treesit-parser-create 'java)))
;;          (java-ts-mode . (lambda () (treesit-parser-create 'java)))
;;          (php-mode . (lambda () (treesit-parser-create 'php)))
;;          (php-ts-mode . (lambda () (treesit-parser-create 'php)))
;;          (toml-ts-mode . (lambda () (treesit-parser-create 'toml)))
;;          (python-ts-mode . (lambda () (treesit-parser-create 'python)))
;;          (python-mode . (lambda () (treesit-parser-create 'python)))))

(use-package treesit-auto
  :straight (:type git :host github :repo "renzmann/treesit-auto")
  :commands (global-treesit-auto-mode)
  :hook (my/startup . global-treesit-auto-mode)
  :config
  (global-treesit-auto-mode)
  (setq treesit-auto-install 'prompt)
  ;; (setq major-mode-remap-alist
  ;;       '((c-mode . c-ts-mode)
  ;;         (c++-mode . c++-ts-mode)
  ;;         (cmake-mode . cmake-ts-mode)
  ;;         (conf-toml-mode . toml-ts-mode)
  ;;         (css-mode . css-ts-mode)
  ;;         (js-mode . js-ts-mode)
  ;;         (js-json-mode . json-ts-mode)
  ;;         (python-mode . python-ts-mode)
  ;;         (sh-mode . bash-ts-mode)
  ;;         (typescript-mode . typescript-ts-mode)
  ;;         (rust-mode . rust-ts-mode)))
  )




(provide 'init-treesit)
