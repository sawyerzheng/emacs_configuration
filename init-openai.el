
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
  (setq magit-gptcommit-llm-provider my/llm-provider-deepseek)
  :bind (:map git-commit-mode-map
              ("C-c C-g" . magit-gptcommit-commit-accept))
  )

(my/straight-if-use '(plz :source (melpa gnu-elpa-mirror)))
(use-package plz
  :defer t
  )

(my/straight-if-use '(plz-event-source :type git :host github :repo "r0man/plz-event-source"))
(use-package plz-event-source
  :defer t
  )

(my/straight-if-use '(plz-media-type :type git :host github :repo "r0man/plz-media-type"))
(use-package plz-media-type
  :defer t
  )

(my/straight-if-use '(llm :type git :host github :repo "ahyatt/llm" :files ("*")))
(with-eval-after-load 'llm
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
  (require 'llm)
  (setq ellama-sessions-directory (expand-file-name "ellama-sessions" no-littering-var-directory))

  (setopt ellama-language "English")
  (setopt ellama-language "汉语")
  ;; could be llm-openai for example
  (setopt ellama-provider my/llm-provider-deepseek)
  (setopt ellama-providers '(("kimi" . my/llm-provider-kimi)
                             ("gpu" . my/llm-provider-gpu)
                             ("deepseek-v2.5" . my/llm-provider-deepseek)
			     ("ollama-deepseek-r1" . my/llm-provider-ollama-deepseek-r1)
			     ("ollama-deepseek-r1-office" . my/llm-provider-ollama-deepseek-r1-office)
			     ("ollama-qwen2.5-coder" . my/llm-provider-ollama-qwen2.5-coder)
			     ("ollama-qwen2.5-coder-office" . my/llm-provider-ollama-qwen2.5-coder-office)
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
    (ellama--replace "\\(^\\|\W\\)__\\(.+?\\)__\\(\W\\|$\\)" "\\1*\\2*\\3" beg end)
    (ellama--replace "\\*\\*\\(.+?\\)\\*\\*" "*\\1*" beg end)
    (ellama--replace "<b>\\(.+?\\)</b>" "*\\1*" beg end)
    ;; italic
    ;; (ellama--replace "_\\(.+?\\)_" "/\\1/" beg end)
    (ellama--replace "\\(^\\|\W\\)_\\(.+?\\)_\\(\W\\|$\\)" "\\1/\\2/\\3" beg end)
    (ellama--replace "<i>\\(.+?\\)</i>" "/\\1/" beg end)
    ;; underlined
    (ellama--replace "<u>\\(.+?\\)</u>" "_\\1_" beg end)
    ;; inline code
    (ellama--replace "`\\(.+?\\)`" "~\\1~" beg end)
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
    (let ((fill-column ellama-long-lines-length)
	  (use-hard-newlines t))
      (fill-region beg end nil t t)))

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
(provide 'init-openai)
