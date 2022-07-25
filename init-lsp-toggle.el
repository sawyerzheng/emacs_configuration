(use-package flycheck
  :straight t
  :defer t
  )
(use-package lsp-mode
  :straight t
  :commands (lsp lsp-mode)
  :init
  (setq lsp-keymap-prefix "M-\"")

  :init
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(flex))
    ;; (tempel-setup-capf)
    ) ;; Configure flex
  :hook
  (lsp-completion-mode . my/lsp-mode-setup-completion)
  :custom
  (lsp-completion-provider :none) ;; we use Corfu!

  )

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

          (define-key map (kbd "gd") 'lsp-treemacs-java-deps-list)
          (define-key map (kbd "gs") 'lsp-treemacs-symbols)
          (define-key map (kbd "=r") 'lsp-format-region)

          ;; errors
          (define-key map (kbd "ee") 'lsp-treemacs-errors-list)
          (define-key map (kbd "en") 'flycheck-next-error)
          (define-key map (kbd "ep") 'flycheck-previous-error)

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
  :defer t)

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

(defvar my/lsp-backend 'lsp-bridge
  "use `lsp-bridge' or `lsp-mode'")

(defun my-disable-company ()
  (company-mode -1))

(defun my/start-lsp-fn ()
  "manage correctly to start lsp-mode"
  (require 'lsp-treemacs)
  (cond ((eq major-mode 'java-mode)
         (require 'lsp-java))
        ((eq major-mode 'python-mode)
         (require 'lsp-pyright))
        ((eq major-mode 'c++-mode)))
  (lsp))

(defun my/start-lsp-bridge-fn ()
  (lsp-bridge-mode))

;; * config
(defcustom my/lsp-toggle-mode-hooks
  '(python-mode-hook c++-mode-hook c-mode-hook)
  "auto toggle for lsp-mode and lsp-bridge")

(defun my-enable-lsp-bridge ()
  (interactive)
  ;; (setq lsp-completion-enable nil)
  ;; (global-lsp-bridge-mode)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (remove-hook hook #'my/start-lsp-fn)
    (add-hook hook #'my/start-lsp-bridge-fn)))

(defun my-enable-lsp-mode ()
  (interactive)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (remove-hook hook #'my/start-lsp-bridge-fn)
    (add-hook hook #'my/start-lsp-fn)))

(defun my-lsp-toggle ()
  (interactive)
  (if (eq my/lsp-backend 'lsp-bridge)
      (progn
        (my-enable-lsp-mode)
        (setq my/lsp-backend 'lsp))
    (my-enable-lsp-bridge)
    (setq my/lsp-backend 'lsp-bridge)))

;; * default to lsp
(dolist (hook '(cmake-mode-hook))
  (add-hook hook #'my/start-lsp-fn))

(global-set-key (kbd "C-c t l")  #'my-lsp-toggle)

(provide 'init-lsp-toggle)
