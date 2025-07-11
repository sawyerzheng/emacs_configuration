
(my/straight-if-use '(async-await :type git :host github :repo "chuntaro/emacs-async-await" :files ("*")))

(defun my/elisp-load-file-existsp (file)
  (interactive)
  (when (file-exists-p file)
    (load-file file)))

(my/straight-if-use '(gptel :type git :host github :repo "karthink/gptel"))
(use-package gptel
  :commands (gptel gptel-mode)
  :config
  (require 'gptel-curl)
  ;; (load-file "~/org/private/openai.el.gpg")
  (setq gptel-default-mode #'org-mode)

   (require 'gptel-openai)
   (require 'gptel-ollama)
  (my/elisp-load-file-existsp "~/org/private/gptel-setup.el")
  )

(my/straight-if-use '(gptel-quick :type git :host github :repo "karthink/gptel-quick"))

(use-package gptel-quick
  :after embark
  :commands (gptel-quick)
  :bind (:map embark-general-map
	      ("?" . gptel-quick)
	 )
  :config
  ;; (with-eval-after-load 'embark
  ;;     (keymap-set embark-general-map "?" #'gptel-quick))
  )


(my/straight-if-use '(ai-org-chat :type git :host github :repo "ultronozm/ai-org-chat.el"))
(use-package ai-org-chat
  :after gptel
  :commands (ai-org-chat-new)
  :config)

(my/straight-if-use '(elysium :type git :host github :repo "lanceberge/elysium"))
(use-package elysium
  :after gptel
  :commands (elysium-query)
  :config
  (setq (elysium-window-size 0.33) ; The elysium buffer will be 1/3 your screen
        (elysium-window-style 'vertical) ; Can be customized to horizontal
        )
  )

(my/straight-if-use '(magit-gptcommit :type git :host github :repo "douo/magit-gptcommit"))
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

(my/straight-if-use '(plz :source (melpa gnu-elpa-mirror)))
(use-package plz
  :defer t
  )

(my/straight-if-use 'plz-event-source)
(use-package plz-event-source
  :defer t
  )

(my/straight-if-use 'plz-media-type)
(use-package plz-media-type
  :defer t
  )

(my/straight-if-use 'llm)
(with-eval-after-load 'llm
  (setq llm-warn-on-nonfree nil)
  (my/elisp-load-file-existsp "~/org/private/gptel-setup.el"))

(my/straight-if-use '(ellama :type git :host github :repo "s-kostyaev/ellama"))
;; (when (file-exists-p (locate-library "ellama-autoloads"))
;;   (require 'ellama-autoloads))

(use-package ellama
  :bind (("C-c i a" . ellama-transient-main-menu))
  :init
  ;; setup key bindings
  ;; (setopt ellama-keymap-prefix "C-c e")
  ;; language you want ellama to translate to
  :commands (ellama-chat-translation-disable
	     ellama-chat-translation-enable)
  :config
  (setenv "OLLAMA_HOST" "http://172.16.10.86:11434")

  (require 'llm)
  (setq ellama-sessions-directory (expand-file-name "ellama-sessions" no-littering-var-directory))

  (setopt ellama-language "English")
  (setopt ellama-language "汉语")
  ;; could be llm-openai for example
  (setopt ellama-provider my/llm-provider-deepseek-chat)
  (setopt ellama-providers '(("kimi" . my/llm-provider-kimi)
                             ("gpu" . my/llm-provider-gpu)
			     ("siliconflow-deepseek-v3" . my/llm-provider-siliconflow-deepseek-v3)
			     ("siliconflow-deepseek-r1" . my/llm-provider-siliconflow-deepseek-r1)
                             ("deepseek-chat" . my/llm-provider-deepseek-chat)
                             ("deepseek-reasoner" . my/llm-provider-deepseek-reasoner)
			     ("ollama-deepseek-r1" . my/llm-provider-ollama-deepseek-r1)
			     ("ollama-deepseek-r1-office" . my/llm-provider-ollama-deepseek-r1-office)
			     ("ollama-qwen2.5-coder" . my/llm-provider-ollama-qwen2.5-coder)
			     ("ollama-qwen2.5-coder-office" . my/llm-provider-ollama-qwen2.5-coder-office)
			     ("ollama-qwen2.5-chat" . my/llm-provider-ollama-qwen2.5-chat)
			     ("ollama-qwen2.5-chat-office" . my/llm-provider-ollama-qwen2.5-chat-office)
			     ("openrouter-deepseek-v3-free". my/llm-provider-openrouter-deepseek-v3-free)

			     ("openrouter-deepseek-r1-free". my/llm-provider-openrouter-deepseek-r1-free)
			     ("openrouter-deepseek-v3". my/llm-provider-openrouter-deepseek-v3)

			     ("openrouter-deepseek-r1". my/llm-provider-openrouter-deepseek-r1)
			     ("openrouter-gemini-flash" . my/llm-provider-openrouter-gemini-flash)
			     )

	  )
  
  ;; (setopt ellama-naming-provider my/llm-provider)
  (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
  ;; (setopt ellama-translation-provider my/llm-provider)
  (setopt ellama-keymap-prefix "C-c i A")
  (with-eval-after-load 'which-key
    (which-key-add-keymap-based-replacements ellama-command-map
      "a" "ellma ask"))

  (setq my/ellma-code-generate-comment-template "Review the following code and make concise code comments in English:\n```\n%s\n```")
  (defun my/ellama-code-generate-comment ()
    "generate coment for the code in selected region or current buffer."
    (interactive)
    (let ((text (if (region-active-p)
		    (buffer-substring-no-properties (region-beginning) (region-end))
		  (buffer-substring-no-properties (point-min) (point-max)))))
      (ellama-instant (format my/ellma-code-generate-comment-template text))))
  ;; (define-key ellama-command-map (kbd "c d") #'my/ellama-code-generate-comment)


  ;; my patch

  (defun ellama--apply-transformations (beg end)
    "Apply md to org transformations for region BEG END."
    ;; headings
    (ellama--replace "^# " "* " beg end)
    (ellama--replace "^## " "** " beg end)
    (ellama--replace "^### " "*** " beg end)
    (ellama--replace "^#### " "**** " beg end)
    (ellama--replace "^##### " "***** " beg end)
    (ellama--replace "^###### " "****** " beg end)
    ;; bold
    ;; (ellama--replace "__\\(.+?\\)__" "*\\1*" beg end)
    (ellama--replace "\\(^\\|\W\\)__\\(.+?\\)__\\(\W\\|$\\)" "\\1*\\2*\\3" beg end) ;; --
    (ellama--replace "\\*\\*\\(.+?\\)\\*\\*" "*\\1*" beg end)
    (ellama--replace "<b>\\(.+?\\)</b>" "*\\1*" beg end)
    (ellama--replace "<i>\\(.+?\\)</i>" "/\\1/" beg end)
    ;; underlined
    (ellama--replace "<u>\\(.+?\\)</u>" "_\\1_" beg end)
    ;; inline code
    (ellama--replace "`\\(.+?\\)`" "~\\1~" beg end)
    ;; italic
    (when ellama-translate-italic
      ;; (ellama--replace "_\\(.+?\\)_" "/\\1/" beg end)
      (ellama--replace "\\(^\\|\W\\)_\\(.+?\\)_\\(\W\\|$\\)" "\\1/\\2/\\3" beg end) ;; --
      )
    ;; lists
    (ellama--replace "^\\* " "+ " beg end)
    ;; strikethrough
    (ellama--replace "~~\\(.+?\\)~~" "+\\1+" beg end)
    (ellama--replace "<s>\\(.+?\\)</s>" "+\\1+" beg end)
    ;; badges
    (ellama--replace "\\[\\!\\[.*?\\](\\(.*?\\))\\](\\(.*?\\))" "[[\\2][file:\\1]]" beg end)
    ;;links
    (ellama--replace "\\[\\(.*?\\)\\](\\(.*?\\))" "[[\\2][\\1]]" beg end)

    ;; horizontal line
    (ellama--replace "^---+$" "-----" beg end)

    ;; filling long lines
    (goto-char beg)
    (when ellama-fill-paragraphs
      (let ((use-hard-newlines t))
	(fill-region beg end nil t t))))

  (setq my/ellama-summarize-prompt-template "<INSTRUCTIONS>
你是一名总结者。你按照以下步骤对输入文本进行总结，*使用与原始输入文本相同的语言*：  
1. 分析输入文本，生成5个关键问题，这些问题在得到解答后能够捕捉文本的主要内容和核心意义。
2. 在制定问题时：  
   a. 涉及核心主题或论点
   b. 识别关键支持观点
   c. 突出重要事实或证据
   d. 揭示作者的目的或视角
   e. 探讨任何重要的影响或结论。
3. 逐一详细回答你生成的所有问题。
</INSTRUCTIONS>
<INPUT>
%s
</INPUT>")


  ;; 修复 ellama-ask-about 结束后，存在一个 posframe buffer 没有被清理的问题

  (defun my/ellama-ask-command-advice-fn (&rest args)
  "fix bug of posfram not hide for ellama ask command"
  (posframe-delete-all))
  (advice-add #'ellama-ask-about :after #'my/ellama-ask-command-advice-fn)
  )


(my/straight-if-use '(minuet-ai :type git :host github :repo "milanglacier/minuet-ai.el"))
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
  (my/elisp-load-file-existsp "~/org/private/gptel-setup.el")

  ;; Required when defining minuet-ative-mode-map in insert/normal states.
  ;; Not required when defining minuet-active-mode-map without evil state.
  ;; (add-hook 'minuet-active-mode-hook #'evil-normalize-keymaps)

  (minuet-set-optional-options minuet-openai-fim-compatible-options :max_tokens 256))

(my/straight-if-use '(aidermacs :host github :repo "MatthewZMD/aidermacs" :files ("*.el")))


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

(my/straight-if-use '(aider :type git :host github :repo "tninja/aider.el" :files ("*.el")))
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

(my/straight-if-use '(emigo :type git :host github :repo "MatthewZMD/emigo" :files ("*")))
(use-package emigo
  :init
  (setq emigo-python-command my/epc-python-command)
  :config
  (emigo-enable) ;; Starts the background process automatically
  (my/elisp-load-file-existsp "~/org/private/gptel-setup.el")
  :commands (emigo)
  )
(provide 'init-openai)
