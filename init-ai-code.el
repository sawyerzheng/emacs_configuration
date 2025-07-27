(defvar my/use-codeium nil
  "if to use codeium"
  )
;; (my/straight-if-use '(copilot :host github :repo "zerolfx/copilot.el" :files ("*.el" "dist")))
;; (use-package copilot
;;   :defer t)

(my/straight-if-use '(codeium :host github :repo "Exafunction/codeium.el"))
(use-package codeium 
  :commands (codeium-init
             codeium-reset
             codeium-install
             codeium-diagnose
             codeium-kill-last-auth-url
             codeium-completion-at-point)
  :after prog-mode
  :init
  (if my/use-codeium
      (add-to-list 'completion-at-point-functions #'codeium-completion-at-point))
  
  :config
  (when my/use-codeium
    (add-hook 'eglot-managed-mode-hook (lambda ()
                                          (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)))
    (add-hook 'lsp-managed-mode-hook (lambda ()
                                       (add-to-list 'completion-at-point-functions #'codeium-completion-at-point))))
  
  (setq use-dialog-box nil) ;; do not use popup boxes
  ;; get codeium status in the modeline
  (setq codeium-mode-line-enable
        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
  (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)

  ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
  (setq codeium-api-enabled
        (lambda (api)
          (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
  ;; you can also set a config for a single buffer like this:
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local codeium/editor_options/tab_size 4)))

  ;; You can overwrite all the codeium configs!
  ;; for example, we recommend limiting the string sent to codeium for better performance
  (defun my-codeium/document/text ()
    (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
  ;; if you change the text, you should also change the cursor_offset
  ;; warning: this is measured by UTF-8 encoded bytes
  (defun my-codeium/document/cursor_offset ()
    (codeium-utf8-byte-length
     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
  (setq codeium/document/text 'my-codeium/document/text)
  (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))

;; (use-package codegeex
;;   :commands (codegeex-mode
;;              codegeex-request-completion
;;              codegeex-completion-at-point)
;;   :bind (:map my/openai-map
;;               ("a" . codegeex-request-completion)))

(defun my/ai-code-capf ()
  (interactive)
  (let (completion-at-point-functions)
    (dolist (backend '(codeium-completion-at-point))
      (when (fboundp backend)
        (add-hook 'completion-at-point-functions backend nil t)))
    (call-interactively #'completion-at-point)))


(my/straight-if-use '(starhugger :type git :host gitlab :repo "daanturo/starhugger.el" :files (:defaults "*.py")))
(use-package starhugger
  :config
  (setq starhugger-ollama-generate-api-url "http://172.16.10.86:11434/api/generate")
  (setq starhugger-completion-backend-function #'starhugger-ollama-completion-api)
  (setopt starhugger-model-id "qwen2.5-coder:1.5b"))



(provide 'init-ai-code)
