(when my/wsl-p

  ;; (defun my/browse-url-wsl-advice (url &rest args)
  ;;   "use windows browser in wsl to open urls"
  ;;   (interactive)
  ;;   (if (and (not (eq browse-url-browser-function 'eaf-open-browser))
  ;;            my/wsl-p
  ;;            (string-match-p "^https?://" url))
  ;;       (shell-command (format "cmd.exe /c start \"%s\"" url))
  ;;     (funcall-interactively browse-url-browser-function url args)))

  

  (advice-add #'browse-url :override #'my/browse-url-wsl-advice)
  (advice-remove #'browse-url  #'my/browse-url-wsl-advice)
  )

;; browser tools
(use-package atomic-chrome
  :straight t
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

(use-package js2-mode
  :straight t
  :mode  ("\\.js\\'" . js2-minor-mode))

(use-package web-mode
  :straight t
  :mode (("\\.html?\\'" . web-mode))
  :hook ((html-mode . web-mode)))

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

(use-package typescript-mode
  :straight (:source (melpa gpu-elpa-mirror))
  :commands (typescript-mode))

;; ref: https://github.com/ananthakumaran/tide
(use-package tide
  :straight t
  :after (web-mode typescript-mode)
  :config
  (defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    ;; company is an optional dependency. You have to
    ;; install it separately via package-install
    ;; `M-x package-install [ret] company`
    (company-mode +1))

  ;; if you use typescript-mode
  (add-hook 'typescript-mode-hook #'setup-tide-mode)

  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t)

  ;; ;; formats the buffer before saving
  ;; (add-hook 'before-save-hook 'tide-format-before-save)

  ;; enable typescript-tslint checker
  (flycheck-add-mode 'typescript-tslint 'web-mode))

(use-package indium
  :straight t)

(use-package emmet-mode
  :straight t
  :hook ((css-mode sgml-mode web-mode) . emmet-mode)
  :bind (:map emmet-mode-keymap
              ("C-<return>" . nil)))

(use-package impatient-mode
  :straight t
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

(use-package jq-mode
  :straight t
  :commands (jq-mode)
  :config
  (with-eval-after-load 'org
    (org-babel-do-load-languages 'org-babel-load-languages
                                 '((jq . t))))
  )


;; ref: https://github.com/pashky/restclient.el
(use-package restclient
  :straight (:files ("*.el"))
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

(use-package company-restclient
  :straight t
  :hook (restclient-mode . my/company-restclient--add-capf)
  :config
  (defun my/company-restclient--add-capf ()
    (add-to-list 'completion-at-point-functions (cape-company-to-capf
                                                 (apply-partially #'company--multi-backend-adapter
                                                                  '(company-restclient))))))

;; ref: https://github.com/federicotdn/verb
(use-package verb
  :straight t)

;; ref: https://github.com/nicferrier/elnode
(use-package elnode
  :straight t
  :commands (list-elnode-servers
             elnode-make-websever))

(provide 'init-web)
