(when my/wsl-p

  ;; (defun my/browse-url-wsl-advice (url &rest args)
  ;;   "use windows browser in wsl to open urls"
  ;;   (interactive)
  ;;   (if (and (not (eq browse-url-browser-function 'eaf-open-browser))
  ;;            my/wsl-p
  ;;            (string-match-p "^https?://" url))
  ;;       (shell-command (format "cmd.exe /c start \"%s\"" url))
  ;;     (funcall-interactively browse-url-browser-function url args)))

  

  ;; (advice-add #'browse-url :override #'my/browse-url-wsl-advice)
  ;; (advice-remove #'browse-url  #'my/browse-url-wsl-advice)
  )

;; browser tools
(my/straight-if-use 'atomic-chrome)

(use-package atomic-chrome
  :commands (atomic-chrome-start-server)
  :config
  (setq atomic-chrome-server-ghost-text-port 4001)

  (setq atomic-chrome-default-major-mode 'python-mode)

  (setq atomic-chrome-url-major-mode-alist
        '(("github\\.com" . gfm-mode)
          ("redmine" . textile-mode))))




;; web development
;; (use-package skewer-mode
;;   :straight t
;;   :hook ((js2-mode css-mode html-mode) . skewer-mode)
;;   )

(my/straight-if-use '(js :type built-in))
(use-package js
  :mode ("\\.js$" . js-mode))

(my/straight-if-use 'js2-mode)
(use-package js2-mode
  :hook (js-mode . js2-minor-mode))

(my/straight-if-use 'web-mode)
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode))
  :hook ((html-mode . web-mode))
  :config
  (setq web-mode-enable-auto-closing t) ; enable auto close tag in text-mode
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-auto-close-style 2)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-imenu-regexp-list
        '(("<\\(h[1-9]\\)\\([^>]*\\)>\\([^<]*\\)" 1 3 ">" nil)
          ("^[ \t]*<\\([@a-z]+\\)[^>]*>? *$" 1 " id=\"\\([a-zA-Z0-9_]+\\)\"" "#" ">")
          ("^[ \t]*<\\(@[a-z.]+\\)[^>]*>? *$" 1 " contentId=\"\\([a-zA-Z0-9_]+\\)\"" "=" ">")
          ;; angular imenu
          (" \\(ng-[a-z]*\\)=\"\\([^\"]+\\)" 1 2 "="))))

;; (use-package vue-mode
;;   :straight (:source (melpa gpu-elpa-mirror))
;;   :mode (("\\.vue\\'" . vue-mode))
;;   :config

;;   )

;; * define a vue-mode
(define-derived-mode vue-mode web-mode "Vue"
  "A major mode derived from web-mode, for editing .vue files with LSP support.")


(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))


(defun vue-eglot-init-options ()
  (let ((tsdk-path (expand-file-name
                    "lib"
                    (string-trim-right (shell-command-to-string "npm list --global --parseable typescript |& head -n1")))))
    `(:typescript (:tsdk ,tsdk-path
                         :languageFeatures (:completion
                                            (:defaultTagNameCase "both"
                                                                 :defaultAttrNameCase "kebabCase"
                                                                 :getDocumentNameCasesRequest nil
                                                                 :getDocumentSelectionRequest nil)
                                            :diagnostics
                                            (:getDocumentVersionRequest nil))
                         :documentFeatures (:documentFormatting
                                            (:defaultPrintWidth 100
                                                                :getDocumentPrintWidthRequest nil)
                                            :documentSymbol t
                                            :documentColor t)))))

;; Volar
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `(vue-mode . ("vue-language-server" "--stdio" :initializationOptions ,(vue-eglot-init-options)))))

;; (use-package vue-mode
;;   :straight (:source (melpa gpu-elpa-mirror))
;;   :mode (("\\.vue\\'" . vue-mode))
;;   :config

;;   )

;; * define a vue-mode
(define-derived-mode vue-mode web-mode "Vue"
  "A major mode derived from web-mode, for editing .vue files with LSP support.")


(add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode))


(defun vue-eglot-init-options ()
  (let ((tsdk-path (expand-file-name
                    "lib"
                    (string-trim-right (shell-command-to-string "npm list --global --parseable typescript |& head -n1")))))
    `(:typescript (:tsdk ,tsdk-path
                         :languageFeatures (:completion
                                            (:defaultTagNameCase "both"
                                                                 :defaultAttrNameCase "kebabCase"
                                                                 :getDocumentNameCasesRequest nil
                                                                 :getDocumentSelectionRequest nil)
                                            :diagnostics
                                            (:getDocumentVersionRequest nil))
                         :documentFeatures (:documentFormatting
                                            (:defaultPrintWidth 100
                                                                :getDocumentPrintWidthRequest nil)
                                            :documentSymbol t
                                            :documentColor t)))))

;; Volar
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `(vue-mode . ("vue-language-server" "--stdio" :initializationOptions ,(vue-eglot-init-options)))))

(my/straight-if-use '(typescript-mode :source (melpa gpu-elpa-mirror)))

(use-package typescript-mode
  :commands (typescript-mode))

;; ref: https://github.com/ananthakumaran/tide
(my/straight-if-use 'tide)
(use-package tide
  :after (web-mode typescript-mode)
  :config
  (setq my/tide-enable-hooks '(web-mode-hook
                               vue-mode-hook
                               js-mode-hook
                               js-ts-mode-hook
                               javascript-mode-hook
                               javascript-ts-mode-hook
                               typescript-mode-hook
                               typescript-ts-mode-hook))
  (defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode 1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode 1)
    (tide-hl-identifier-mode 1)
    ;; company is an optional dependency. You have to
    ;; install it separately via package-install
    ;; `M-x package-install [ret] company`
    (if (featurep 'corfu)
        ;; use corfu
        (progn
          (corfu-mode +1)
          (unless (fboundp #'cape-company-to-capf)
            (require 'cape))
          (add-to-list 'completion-at-point-functions
                       (cape-company-to-capf #'company-tide)))
      ;; use company
      (company-mode 1))

    ;; disable lsp backend
    (dolist (hook my/tide-enable-hooks)

      (remove-hook hook #'my-start-eglot-fn)
      (remove-hook hook #'my-start-lsp-bridge-fn)
      (remove-hook hook #'my-start-lsp-mode-fn)))

  ;; if you use typescript-mode
  (my/enable-tide)


  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t)

  ;; ;; formats the buffer before saving
  ;; (add-hook 'before-save-hook 'tide-format-before-save)

  ;; enable typescript-tslint checker
  (flycheck-add-mode 'typescript-tslint 'web-mode))

(defun my/enable-tide ()
  (interactive)
  (dolist (hook my/tide-enable-hooks)
    (add-hook hook #'setup-tide-mode)))


(defun my/disable-tide ()
  (interactive)
  (dolist (hook my/tide-enable-hooks)
    (remove-hook hook #'setup-tide-mode)))

(my/straight-if-use 'indium)
;; * javascript 工具
;; - 依赖： ~npm install -g indium~
;;
(use-package indium
  :commands (indium-scratch
             indium-switch-to-repl-buffer))

(my/straight-if-use 'emmet-mode)
(use-package emmet-mode
  :hook ((css-mode sgml-mode web-mode) . emmet-mode)
  :bind (:map emmet-mode-keymap
              ("C-<return>" . nil)))

(my/straight-if-use 'impatient-mode)
(use-package impatient-mode
  :commands (impatient-mode)
  :config
  ;; (defun my/impatient-mode-open-current-buffer ()
  ;;   (interactive)
  ;;   (let* ((url (format "http://%s:%s/imp/live/%s" (if httpd-host
  ;;                                                      httpd-host
  ;;                                                    "localhost") httpd-port (file-name-nondirectory (buffer-file-name)))))
  ;;     (browse-url url)))
  (add-hook 'impatient-mode-hook 'httpd-start)
  ;; (add-hook 'impatient-mode-hook #'imp-visit-buffer)
  )

(my/straight-if-use 'jq-mode)
(use-package jq-mode
  :commands (jq-mode)
  :config
  (with-eval-after-load 'org
    (org-babel-do-load-languages 'org-babel-load-languages
                                 '((jq . t))))
  )


;; ref: https://github.com/pashky/restclient.el
(my/straight-if-use '(restclient :files ("*.el")))
(use-package restclient
  :mode ("\\.http\\'" . restclient-mode)
  :hook (restclient-mode . display-line-numbers-mode)
  :commands (restclient-mode)
  :config

  (require 'restclient-jq)

  ;; * keymap
  ;;
  ;; ** trigger request
  ;; - C-c C-c default get
  ;; - C-c C-r raw
  ;; - C-c C-v view
  ;;
  ;;
  ;; ** jump
  ;;
  ;; - C-c C-p
  ;; - C-c C-n
  ;;
  ;; ** mark
  ;; - C-c C-.
  ;;
  ;;
  ;; ** copy
  ;;
  ;; - curl: C-c C-u : =curl= copy as curl command
  ;; - 参数： C-c C-g : 参数设置（helm)
  ;; - 对齐： C-c C-a : align
  ;; - info: C-c C-i : information of restclient
  ;; - 折叠： TAB     : 隐藏 request body
  ;; - narrow: C-c n n: narrow to current request

  )

(my/straight-if-use 'company-restclient)
(use-package company-restclient
  :hook (restclient-mode . my/company-restclient--add-capf)
  :config
  (defun my/company-restclient--add-capf ()
    (add-to-list 'completion-at-point-functions (cape-company-to-capf
                                                 (apply-partially #'company--multi-backend-adapter
                                                                  '(company-restclient))))))

;; ref: https://github.com/federicotdn/verb
(my/straight-if-use 'verb)


;; ref: https://github.com/nicferrier/elnode
(my/straight-if-use 'elnode)
(use-package elnode
  :commands (list-elnode-servers
             elnode-make-websever))

(provide 'init-web)
