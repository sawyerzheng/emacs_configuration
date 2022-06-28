(use-package lsp-mode
  :straight t
  :commands (lsp lsp-mode)
  :init
  (setq lsp-keymap-prefix "M-\"")
  )

(use-package lsp-java
  :straight t
  :after lsp-mode
  :config
  (setq  my:java-map
	 (let* ((map (make-sparse-keymap)))
	   ;; format
	   ;; (define-key map (kbd "==") '("lsp format buffer" . (lambda ()
	   ;;      						(interactive)
	   ;;      						;; (setq tab-width 4)
	   ;;      						(lsp-format-buffer))))
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

	   map)
	 )

  (define-key java-mode-map (kbd "M-\"") my:java-map)
  (require 'dap-java)

  ;; run main function, 参考： https://emacs-china.org/t/lsp-java-main-class/12371/7 
  (dap-register-debug-template
   "Java Run"
   (list :type "java"
         :request "launch"
         :args ""
         :noDebug t
         :cwd nil
         :host "localhost"
         :request "launch"
         :modulePaths []
         :classPaths nil
         :name "JavaRun"
         :projectName nil
         :mainClass nil))
  )

;; corfu + lsp-mode
(use-package lsp-mode
  :custom
  (lsp-completion-provider :none) ;; we use Corfu!
  :init
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))) ;; Configure orderless
  :hook
  (lsp-completion-mode . my/lsp-mode-setup-completion))

(defvar my-lsp-backend 'lsp-bridge
  "use `lsp-bridge' or `lsp-mode'")

(defun my-disable-company ()
  (company-mode -1))

(defun my-enable-lsp-bridge ()
  (interactive)
  (setq lsp-completion-enable nil)
  ;; (global-lsp-bridge-mode)
  (remove-hook 'python-mode-hook #'lsp)
  (add-hook 'python-mode-hook #'lsp-bridge-mode))

(defun my-enable-lsp-mode ()
  (interactive)
  (with-eval-after-load 'lsp
      (require 'lsp-pyright))

  (setq lsp-completion-enable t)
  (add-hook 'python-mode-hook #'lsp)
  ;; (global-lsp-bridge-mode)
  (remove-hook 'python-mode-hook #'lsp-bridge-mode))

(defun my-lsp-toggle ()
  (interactive)
  (if (eq my-lsp-backend 'lsp-bridge)
      (my-enable-lsp-mode)
    (my-enable-lsp-bridge)
    ))


(global-set-key (kbd "C-c t l")  #'my-lsp-toggle)

(provide 'init-lsp-toggle)
