
(defvar my/lsp-basic-map nil
  "parent keymap for all sub-keymaps")
(setq my/lsp-basic-map
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "ee") '("consult errors" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (consult-flymake))
                                             (flycheck-mode
                                              (consult-lsp-diagnostics))
                                             (lsp-bridge-mode
                                              (lsp-bridge-list-diagnostics))
                                             (t
                                              nil)))) )
        (define-key map (kbd "el") '("list errors" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-show-buffer-diagnostics))
                                             (flycheck-mode
                                              (flycheck-list-errors))
                                             (lsp-bridge-mode
                                              (lsp-bridge-list-diagnostics))
                                             (t
                                              nil))
                                       )))
        (define-key map (kbd "en") '("next error" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-goto-next-error))
                                             (flycheck-mode
                                              (flycheck-next-error))
                                             (lsp-bridge-mode
                                              (lsp-bridge-jump-to-next-diagnostic))
                                             (t
                                              nil)))))
        (define-key map (kbd "ep") '("prev error" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-goto-prev-error))
                                             (flycheck-mode
                                              (flycheck-previous-error))
                                             (lsp-bridge-mode
                                              (lsp-bridge-jump-to-prev-diagnostic))
                                             (t
                                              nil)))))
        (define-key map (kbd "es") '("error at point" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-show-diagnostic (point)))
                                             (flycheck-mode
                                              (flycheck-explain-error-at-point))
                                             (lsp-bridge-mode ;; no support
                                              nil)
                                             (t
                                              nil))
                                       )))
        map))

(use-package flycheck
  :straight t
  :defer t
  )
(use-package lsp-mode
  :straight t
  :commands (lsp lsp-mode)
  :init
  (setq lsp-keymap-prefix "M-'")

  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(flex))
    ;; (tempel-setup-capf)
    ) ;; Configure flex
  :hook
  (lsp-completion-mode . my/lsp-mode-setup-completion)
  :custom
  (lsp-completion-provider :none) ;; we use Corfu!

  :bind (:map lsp-mode-map
              ("M-." . lsp-find-definition)
              ("M-?" . lsp-find-references))
  :config
  (setq lsp-diagnostics-provider :flymake)
  ;; (setq lsp-diagnostics-provider :flycheck)

  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-folding nil)
  (setq lsp-enable-text-document-color nil)
  )

(use-package consult-lsp
  :straight t
  :after (lsp-mode consult)
  :commands (consult-lsp-diagnostics
             consult-lsp-symbols
             consult-lsp-file-symbols))

(use-package lsp-java
  :defer t
  :straight t
  :after lsp-mode
  :config
  (setq my:java-map
        (let* ((map (make-sparse-keymap)))
          ;; format
          ;; (define-key map (kbd "==") '("lsp format buffer" . (lambda ()
          ;;      						(interactive)
          ;;      						;; (setq tab-width 4)
          ;;      						(lsp-format-buffer))))
          (set-keymap-parent map my/lsp-basic-map)
          (define-key map (kbd "gd") 'lsp-treemacs-java-deps-list)
          (define-key map (kbd "gs") 'lsp-treemacs-symbols)
          (define-key map (kbd "=r") 'lsp-format-region)

          ;; errors
          (define-key map (kbd "eE") 'lsp-treemacs-errors-list)

          ;; generate codes--- make(mine)  codes
          (define-key map (kbd "mg") 'lsp-java-generate-getters-and-setters)
          (define-key map (kbd "ms") 'lsp-java-generate-to-string)
          (define-key map (kbd "me") 'lsp-java-generate-equals-and-hash-code)
          (define-key map (kbd "mo") 'lsp-java-generate-overrides)

          (define-key map (kbd "mcf") 'lsp-java-create-field)
          (define-key map (kbd "mcl") 'lsp-java-create-local)
          (define-key map (kbd "mcp") 'lsp-java-create-parameter)
          (define-key map (kbd "mi") 'lsp-java-add-import)
          (define-key map (kbd "mmc") 'lsp-java-create-method)
          (define-key map (kbd "mmu") 'lsp-java-add-unimplemented-methods)

          ;; dap test
          (define-key map (kbd "tm") 'dap-java-run-test-method)
          (define-key map (kbd "tc") 'dap-java-run-test-class)
          (define-key map (kbd "tt") '("dap test method" . (lambda ()
                                                             (interactive)
                                                             (let* ((prev-language-environment current-language-environment))
                                                               (if (eq system-type 'windows-nt)
                                                                   (set-language-environment 'Chinese-GBK))
                                                               (projectile-save-project-buffers)
                                                               (dap-java-run-test-method)
                                                               ;; (set-language-environment prev-language-environment)
                                                               ))))

          ;; dap debug
          (define-key map (kbd "dm") 'dap-java-debug-test-method)
          (define-key map (kbd "dc") 'dap-java-debug-test-class)
          (define-key map (kbd "dd") 'dap-java-debug)

          map))

  (define-key java-mode-map (kbd "M-\"") my:java-map))

;; corfu + lsp-mode
;; (use-package lsp-mode
;;   :straight t
;;   :custom
;;   (lsp-completion-provider :none) ;; we use Corfu!
;;   :init
;;   (defun my/lsp-mode-setup-completion ()
;;     (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
;;           '(orderless))) ;; Configure orderless
;;   :hook
;;   (lsp-completion-mode . my/lsp-mode-setup-completion))

(use-package lsp-pyright
  :straight t
  :defer t
  :config
  ;; my own map
  (defvar my:python-map (make-sparse-keymap)
    "my own keymap for python")

  (which-key-add-major-mode-key-based-replacements 'python-mode
                                                   "M-' =" "format"
                                                   "M-' e" "errors"
                                                   "M-' g" "generates"
                                                   "M-' t" "tests"
                                                   "M-' d" "debugs"

                                                   "M-' ==" "lsp format buffer"
                                                   )

  (setq  my:python-map
	 (let* ((map (make-sparse-keymap)))
	   ;; format
           (set-keymap-parent map my/lsp-basic-map)
	   (define-key map (kbd "==") '("lsp format buffer" . (lambda ()
								(interactive)
								;; (setq tab-width 4)
								(lsp-format-buffer))))
	   (define-key map (kbd "=r") 'lsp-format-region)

	   ;; errors
	   (define-key map (kbd "eE") 'lsp-treemacs-errors-list)

	   ;; dap test
	   (define-key map (kbd "ta") 'pytest-all)
	   (define-key map (kbd "tm") 'pytest-module)
	   (define-key map (kbd "tt") '("dap test method" . dap-python-debug-test-at-point))

	   (define-key map (kbd "r") '("dap run buffer" . (lambda ()
							    (interactive)
							    (dap-debug (dap-python--template "Python :: Run file (buffer)")))))
	   map)
	 )

  (define-key python-mode-map (kbd "M-'") my:python-map))

(use-package lsp-treemacs
  :straight t
  :defer t
  :commands (lsp-treemacs-call-hierarchy
             lsp-treemacs-symbols
             lsp-treemacs-errors-list
             lsp-treemacs-references
             lsp-treemacs-implementations
             lsp-treemacs-call-hierarchy
             lsp-treemacs-type-hierarchy
             lsp-treemacs-java-deps-list))

(defvar my/lsp-backend nil
  "use `lsp-bridge' or `lsp-mode' or `eglot'")

(defun my-disable-company ()
  (company-mode -1))

(defun my-start-lsp-mode-fn ()
  "manage correctly to start lsp-mode"
  (interactive)
  (require 'lsp-treemacs)
  (cond ((eq major-mode 'java-mode)
         (require 'lsp-java))
        ((eq major-mode 'python-mode)
         (require 'lsp-pyright))
        ((eq major-mode 'c++-mode)))
  (unless (memq major-mode '(python-mode java-mode))
    (define-key lsp-mode-map (kbd "M-\'") my/lsp-basic-map))
  (lsp))

(defun my-start-lsp-bridge-fn ()
  (interactive)
  (lsp-bridge-mode))

(defun my-start-eglot-fn ()
  (interactive)
  (eglot-ensure))

;; * config
(defcustom my/lsp-toggle-mode-hooks
  '(python-mode-hook c++-mode-hook c-mode-hook cmake-mode-hook)
  "auto toggle for lsp-mode and lsp-bridge")

(defun my-enable-lsp-bridge ()
  (interactive)
  ;; (setq lsp-completion-enable nil)
  ;; (global-lsp-bridge-mode)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (add-hook hook #'my-start-lsp-bridge-fn))
  (my-disable-lsp-mode)
  (my-disable-eglot))

(defun my-enable-lsp-mode ()
  (interactive)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (add-hook hook #'my-start-lsp-mode-fn))
  (my-disable-eglot)
  (my-disable-lsp-bridge)
  )

(defun my-enable-eglot ()
  (interactive)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (add-hook hook #'my-start-eglot-fn))
  (my-disable-lsp-mode)
  (my-disable-lsp-bridge))

(defun my-disable-lsp-bridge ()
  (interactive)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (remove-hook hook #'my-start-lsp-bridge-fn)))

(defun my-disable-lsp-mode ()
  (interactive)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (remove-hook hook #'my-start-lsp-mode-fn)))

(defun my-disable-eglot ()
  (interactive)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (remove-hook hook #'my-start-eglot-fn)))

(use-package consult-eglot
  :straight t
  :commands (consult-eglot-symbols))

(use-package eglot
  :straight t
  :commands (eglot eglot-ensure)
  :config
  (defun my-eglot-restart ()
    (interactive)
    (eglot-shutdown)
    (eglot))

  (defvar my-eglot-keymap
    nil
    "my keymap for eglot-mode")
  (setq my-eglot-keymap
        (let ((map (make-sparse-keymap)))
          (set-keymap-parent map my/lsp-basic-map)
          (bind-key "wr" #'my-eglot-restart map)
          (bind-key "wk" #'eglot-shutdown map)
          (bind-key "wc" #'eglot-reconnect map)

          (bind-key "rr" #'eglot-rename map)

          (bind-key "==" #'eglot-format map)
          (bind-key "=b" #'eglot-format-buffer map)

          (bind-key "hh" #'eldoc-doc-buffer map)
          (bind-key "hm" #'eglot-manual map)

          map))
  (bind-key "M-'" my-eglot-keymap eglot-mode-map)

  (setq completion-category-defaults nil)

  )

(defun my-lsp-toggle ()
  (interactive)
  (let* ((lsp-backends '(("lsp-mode" . my-enable-lsp-mode)
                         ("lsp-bridge" . my-enable-lsp-bridge)
                         ("eglot" . my-enable-eglot)))
         (backend-name (completing-read
                        "choose lsp backend:" (mapcar #'car lsp-backends)))
         (selected-backend (cdr
                            (assoc backend-name lsp-backends))))
    (setq my/lsp-backend backend-name)
    (funcall selected-backend)
    (message "selected backend: %s" backend-name)))

;; * default to lsp
;; (dolist (hook '(cmake-mode-hook))
;;   (add-hook hook #'my-start-eglot-fn))

(global-set-key (kbd "C-c t l")  #'my-lsp-toggle)

(provide 'init-lsp-toggle)
