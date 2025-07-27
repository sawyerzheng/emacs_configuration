

(my/straight-if-use '(ai-org-chat :type git :host github :repo "ultronozm/ai-org-chat.el"))
(use-package ai-org-chat
  :after gptel
  :commands (ai-org-chat-new)
  :config)

(use-package init-gptel)
(use-package elysium
  :after gptel
  :commands (elysium-query)
  :config
  (setq (elysium-window-size 0.33) ; The elysium buffer will be 1/3 your screen
        (elysium-window-style 'vertical) ; Can be customized to horizontal
        )
  )

;; use llm.el as backend
(use-package magit-gptcommit
  :after magit
  :config

  ;; Enable magit-gptcommit-mode to watch staged changes and generate commit message automatically in magit status buffer
  ;; This mode is optional, you can also use `magit-gptcommit-generate' to generate commit message manually
  ;; `magit-gptcommit-generate' should only execute on magit status buffer currently
  ;; (magit-gptcommit-mode 1)

  ;; Add gptcommit transient commands to `magit-commit'
  ;; Eval (transient-remove-suffix 'magit-commit '(1 -1)) to remove gptcommit transient commands
  (magit-gptcommit-status-buffer-setup)
  (setq magit-gptcommit-llm-provider my/llm-provider-deepseek-chat)
  :bind (:map git-commit-mode-map
              ("C-c C-g" . magit-gptcommit-commit-accept))
  )

(use-package plz
  :defer t)

(use-package plz-event-source
  :defer t)

(use-package plz-media-type
  :defer t)

(with-eval-after-load 'llm
  (setq llm-warn-on-nonfree nil))

;; (when (file-exists-p (locate-library "ellama-autoloads"))
;;   (require 'ellama-autoloads))

(use-package init-ellama)

(use-package minuet
  :commands (minuet-auto-suggestion-mode
	     minuet-show-suggestion
	     minuet-complete-with-minibuffer)
  :bind
  (:map minuet-active-mode-map
	("C-M-i" . #'minuet-show-suggestion)
	("C-M-y" . #'minuet-complete-with-minibuffer)
	)
  :bind
  (
   ;; ("M-y" . #'minuet-complete-with-minibuffer) ;; use minibuffer for completion
   ;; ("M-i" . #'minuet-show-suggestion) ;; use overlay for completion

   :map minuet-active-mode-map
   ;; These keymaps activate only when a minuet suggestion is displayed in the current buffer
   ("M-p" . #'minuet-previous-suggestion) ;; invoke completion or cycle to next completion
   ("M-n" . #'minuet-next-suggestion) ;; invoke completion or cycle to previous completion
   ("M-A" . #'minuet-accept-suggestion) ;; accept whole completion
   ;; Accept the first line of completion, or N lines with a numeric-prefix:
   ;; e.g. C-u 2 M-a will accepts 2 lines of completion.
   ("M-a" . #'minuet-accept-suggestion-line)
   ("M-e" . #'minuet-dismiss-suggestion))

  :init
  ;; if you want to enable auto suggestion.
  ;; Note that you can manually invoke completions without enable minuet-auto-suggestion-mode
  ;; (add-hook 'prog-mode-hook #'minuet-auto-suggestion-mode)

  

  :config
  (setq minuet-provider 'openai-fim-compatible)
  ;; Required when defining minuet-ative-mode-map in insert/normal states.
  ;; Not required when defining minuet-active-mode-map without evil state.
  ;; (add-hook 'minuet-active-mode-hook #'evil-normalize-keymaps)

  (minuet-set-optional-options minuet-openai-fim-compatible-options :max_tokens 256))



;; (use-package aidermacs
;;   :commands (aidermacs-transient-menu)
;;   :bind (("C-c i b" . aidermacs-transient-menu))
;;   :init
;;   (setq aidermacs-popular-models '("ollama/qwen2.5-coder:1.5b"
;; 				   "ollama/qwen2.5-coder:3b"
;; 				   "ollama/qwen2.5:1.5b"
;; 				   "ollama/qwen2.5:3b"
;; 				   "ollama/deepseek-r1:1.5b"

;; 				   ))
;;   :config
;;   (setq aidermacs-default-model "ollama/qwen2.5-coder:1.5b")
;;   (setq aidermacs-architect-model "ollama/deepseek-r1:1.5b")
;;   (setq aidermacs-editor-model "ollama/qwen2.5-coder:1.5b")

;;   (setq aidermacs-architect-model "openai/chat-llm")
;;   (setq aidermacs-architect-model "ollama/deepseek-r1:1.5b-qwen-distill-q8_0")

;;   (setenv "OPENAI_API_KEY" "EMPTY")
;;   (setenv "OPENAI_API_BASE" "http://172.16.10.88:18000/v1/")
;;   (setenv "OLLAMA_API_BASE" "http://172.16.10.86:11434")

;;   ; See the Configuration section below
;;   (setq aidermacs-auto-commits t)
;;   (setq aidermacs-use-architect-mode t))


;; (use-package aider
;;   :config
;;   ;; For claude-3-5-sonnet
;;   (setq aider-args '("--model" "sonnet"))
;;   (setenv "ANTHROPIC_API_KEY" anthropic-api-key)
;;   ;; Or chatgpt model
;;   ;; (setq aider-args '("--model" "o3-mini"))
;;   ;; (setenv "OPENAI_API_KEY" <your-openai-api-key>)
;;   ;; Or use your personal config file
;;   ;; (setq aider-args `("--config" ,(expand-file-name "~/.aider.conf.yml")))
;;   ;; ;;
;;   ;; Optional: Set a key binding for the transient menu
;;   ;; (global-set-key (kbd "C-c a") 'aider-transient-menu)
;;   )

(use-package emigo
  :init
  (setq emigo-python-command my/epc-python-command)
  :config
  (emigo-enable) ;; Starts the background process automatically
  :commands (emigo)
  )
(provide 'init-openai)
