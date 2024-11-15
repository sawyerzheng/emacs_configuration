(use-package chatgpt
  :straight (:type git :host github :repo "joshcho/ChatGPT.el" :files ("*"))
  :commands (chatgpt-login              ;; shell
             chatgpt-query
             chatgpt-reset
             chatgpt-display
             chatgpt-stop
             )
  :config
  (setq chatgpt-repo-path (file-name-directory (locate-library "chatgpt")))
  (unless (boundp 'python-interpreter)
    (setq python-interpreter "/usr/bin/python")))

(defun my/openai-load-api-key ()
  (interactive)
  (unless (and (boundp 'openai-key) (not (equal openai-key "")) (not (equal (getenv "OPENAI_API_KEY") "")))
    ;; (load-file "~/org/private/openai.el.gpg")
    (setq openai-key "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")
    ;; (setq openai-key "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJhcHAiLCJzdWIiOiI3MDc1NDIiLCJhdWQiOiJXRUIiLCJpYXQiOjE2ODcyMzc3MDAsImV4cCI6MTY4Nzg0MjUwMH0.IZP2-IXJZiqlE7ehSion4oEHmf8NjmWvEuzyn9obo7E")
    )
  (setenv "OPENAI_API_KEY" openai-key))
(my/openai-load-api-key)

(use-package openai
  :straight (:type git :host github :repo "emacs-openai/openai")
  :defer t
  :config
  (my/openai-load-api-key))

(use-package my-chatgpt-interface
  :commands (my/chatgpt-interface-prompt
             my/chatgpt-interface-async-prompt
             my/chatgpt-interface-prompt-region
             my/chatgpt-interface-prompt-region-action)
  :config
  (setq my/chatgpt-interface-max-tokens 1000)
  (setq my/chatgpt-interface-model "gpt-3.5-turbo")
  (setq my/chatgpt-interface-action-default-model "gpt-3.5-turbo")
  (setq my/chatgpt-interface-action-alist
        '(("custom" . "Write your own instruction")
          ("doc" . "Write documentation for the following code")
          ("fix" . "Find problems with the fllowing code")
          ("explain" . "Explain the flollowing code.")
          ("improve" . "Please improve or optimize the following code.")
          ("test" . "Write me a tests for this code")
          ("completion" . "completion code with following demands:")
          ("translate" . "翻译下面的文本：")
          ))

  (setq my/chatgpt-interface-model "gpt-3.5-turbo")
  (setq my/chatgpt-interface-code-action '("fix" "improve" "test" "completion"))
  (setq my/chatgpt-interface-mode-lang-alist
        '((emacs-lisp-mode . "elisp")
          (artist-mode . "ditaa")
          (fundamental-mode . "dot")
          (sql-mode . "sqlite")
          (fundamental-mode . "calc")
          (c-mode . "c")
          (c++-mode . "cpp")
          (sh-mode . "sh")
          (python-mode . "python")
          (java-mode . "java"))))

(use-package gavinok-chatgpt
  ;; :straight (:type git :host github :repo "bx-blee/chatGptInv")
  ;; ref:
  ;; 1. https://gist.github.com/Gavinok/a18e0b2dac74e4ae67df35e45a170f7f
  ;; 2. https://github.com/bx-blee/chatGptInv
  :commands (chatgpt-fix-region
             chatgpt-explain-region
             chatgpt-gen-tests-for-region
             chatgpt-refactor-region
             chatgpt-prompt
             chatgpt-prompt-region
             chatgpt-prompt-region-and-replace)
  :defer t
  :config
  (require 'openai)
  (my/openai-load-api-key)
  (setq chatgpt-buffer "*ChatGPT Gavinok*"
        chatgpt-max-tokens 1200
        chatgpt-temperature 1)

  (defun chatgpt--query-open-api (prompt callback)
    "Send a string PROMPT to OpenAI API and pass the resulting buffer to CALLBACK.
The environment variable OPENAI_API_KEY is used as your API key

You can register an account here
https://beta.openai.com/docs/introduction/key-concepts"
    (let* ((api-key ;; (getenv "OPENAI_API_KEY")
            openai-key
            )
           (url-request-method (encode-coding-string "POST" 'us-ascii))
	   (url-request-extra-headers `(("Content-Type" . "application/json")
				        ("Authorization" . ,(format "Bearer %s" api-key))))
           (url-request-data (json-encode
			      `(("model" . "text-davinci-003")
			        ("prompt" . ,prompt)
			        ("max_tokens" . ,chatgpt-max-tokens)
			        ("temperature" . 0)))))
      (cl-assert (not (string= "" api-key))
                 t
                 "Current contents of the environmental variable OPENAI_API_KEY
are '%s' which is not an appropriate OpenAI token please ensure
you have the correctly set the OPENAI_API_KEY variable"
                 api-key)
      (url-retrieve
       "https://api.openai.com/v1/completions"
       'chatgpt--parse-response
       (list callback))))
  )


(use-package codegpt
  :straight (codegpt :type git :host github :repo "emacs-openai/codegpt")
  :commands (codegpt-doc
             codegpt-fix
             codegpt-explain
             codegpt-improve
             codegpt-custom             ;; 代码补全
             ))

(defvar my/openai-map (make-sparse-keymap)
  "key bindings for chatgpt and openai tools")

(defun my/chatgpt-prompt (&optional arg)
  (interactive "p")
  (let (start end multiline-p)
    (save-restriction
      (if (region-active-p)
          (progn
            (setq start (region-beginning)
                  end (region-end)
                  multiline-p (/= (line-number-at-pos start)
                                  (line-number-at-pos end)))
            (deactivate-mark)
            (if arg
                (chatgpt-prompt-region-and-replace start end)
              (chatgpt-prompt-region start end)))
        (call-interactively #'chatgpt-prompt))
      )))

(define-key my/openai-map (kbd "c e") #'codegpt-explain)
(define-key my/openai-map (kbd "c d") #'codegpt-doc)
(define-key my/openai-map (kbd "c f") #'codegpt-fix)
(define-key my/openai-map (kbd "c i") #'codegpt-improve)
(define-key my/openai-map (kbd "c c") #'my/chatgpt-interface-prompt-region-action)

(define-key my/openai-map (kbd "l") #'chatgpt-login)
(define-key my/openai-map (kbd "q") #'chatgpt-query)

(define-key my/openai-map (kbd "p") #'my/chatgpt-interface-prompt-region)
(define-key my/openai-map (kbd "f") #'chatgpt-fix-region)
(define-key my/openai-map (kbd "e") #'chatgpt-explain-region)
(define-key my/openai-map (kbd "t") #'chatgpt-gen-tests-for-region)
(define-key my/openai-map (kbd "r") #'chatgpt-refactor-region)


(use-package mind-wave
  :straight (:type git :host github :repo "manateelazycat/mind-wave" :files ("*"))
  :commands (mind-wave-chat-ask
             mind-wave-chat-mode
             mind-wave-edit-mode
             mind-wave-summary-web
             mind-wave-comment-code
             mind-wave-explain-code
             mind-wave-kill-process
             mind-wave-chat-continue
             mind-wave-summary-video
             mind-wave-refactory-code
             mind-wave-restart-process
             mind-wave-chat-parse-title
             mind-wave-edit-mode-cancel
             mind-wave-proofreading-doc
             mind-wave-edit-mode-confirm
             mind-wave-chat-generate-title
             mind-wave-chat-ask-insert-line
             mind-wave-chat-ask-send-buffer
             mind-wave-translate-to-english
             mind-wave-chat-ask-with-multiline
             )
  :config
  (setq mind-wave-python-command my/epc-python-command)
  (defcustom mind-wave-translate-role-chinese "You are an Chinese Translator to translate document to Chinese."
    "Role for translate."
    :type 'string
    :group 'mind-wave)

  (defun mind-wave-translate-to-chinese ()
    (interactive)
    (let* ((info (mind-wave-get-region-or-sexp))
           (translate-start (nth 0 info))
           (translate-end (nth 1 info))
           (translate-text (nth 2 info)))
      (message "Translate...")
      (mind-wave-call-async "adjust_text"
                            (buffer-file-name)
                            (mind-wave--encode-string translate-text)
                            translate-start
                            translate-end
                            mind-wave-translate-role-chinese
                            "Please translate the following paragraph, if the content includes Markdown content, the translated content should keep the same Markdown syntax"
                            "Translate done"
                            )))
  (load-file "~/org/private/mind-wave.el"))

(use-package async-await
  :straight (:type git :host github :repo "chuntaro/emacs-async-await" :files ("*")) )

(use-package aichat
  :straight (:type git :host github :repo "xhcoding/emacs-aichat" :files ("*"))
  :commands (aichat-bingai-chat
             aichat-bingai-assistant
             aichat-bingai-replace-or-insert
             aichat-openai-chat
             aichat-openai-chat-mode)
  :config
  (setq aichat-bingai-cookies-file "~/org/private/bing-cookies.json")
  (setq aichat-bingai-proxy "192.168.1.129:7890")
  (when my/windows-p
    (setq aichat-curl-program "d:/soft/scoop/shims/curl.exe")))

;; (use-package chatgpt-shell
;;   :straight (:type git :host github :repo "xenodium/chatgpt-shell" :files ("*")))

(defun my/elisp-load-file-existsp (file)
  (interactive)
  (when (file-exists-p file)
    (load-file file)))

(use-package gptel
  :straight (:type git :host github :repo "karthink/gptel")
  :commands (gptel gptel-mode)
  :config
  ;; (load-file "~/org/private/openai.el.gpg")
  (setq gptel-default-mode #'org-mode)

  (my/elisp-load-file-existsp "~/org/private/gptel-setup.el")
  )

(use-package gptel-quick
  :straight (:type git :host github :repo "karthink/gptel-quick")
  :after gptel
  :commands (gptel-quick)
  :config
  (keymap-set embark-general-map "?" #'gptel-quick)
  )

(with-eval-after-load 'embark
  (require 'gptel-quick)
  (keymap-set embark-general-map "?" #'gptel-quick))


(use-package ai-org-chat
  :straight (:type git :host github :repo "ultronozm/ai-org-chat.el")
  :after gptel
  :commands (ai-org-chat-new)
  :config)

(use-package elysium
  :straight (:type git :host github :repo "lanceberge/elysium")
  :after gptel
  :commands (elysium-query)
  :config
  (setq (elysium-window-size 0.33) ; The elysium buffer will be 1/3 your screen
        (elysium-window-style 'vertical) ; Can be customized to horizontal
        )
  )

(use-package magit-gptcommit
  :straight (:type git :host github :repo "douo/magit-gptcommit")
  :demand t
  :after gptel magit
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

;; (use-package consult-omni
;;   :straight (:type git :host github :repo "armindarvish/consult-omni")
;;   )


(use-package plz
  :straight (:source (melpa gnu-elpa-mirror))
  ;; :straight (:type git :host github :repo "alphapapa/plz.el")
  :defer t
  )

(use-package plz-event-source
  :straight (:type git :host github :repo "r0man/plz-event-source")
  :defer t
  )

(use-package plz-media-type
  :straight (:type git :host github :repo "r0man/plz-media-type")
  :defer t
  )

(use-package llm
  :straight (:type git :host github :repo "ahyatt/llm" :files ("*") :build (:not compile))
  :demand t
  :config

  (my/elisp-load-file-existsp "~/org/private/gptel-setup.el")
  )

(use-package ellama
  :straight (:type git :host github :repo "s-kostyaev/ellama")
  :after llm
  :init
  ;; setup key bindings
  ;; (setopt ellama-keymap-prefix "C-c e")
  ;; language you want ellama to translate to

  :config
  (setopt ellama-language "English")
  (setopt ellama-language "汉语")
  ;; could be llm-openai for example
  (setopt ellama-provider my/llm-provider-deepseek)
  (setopt ellama-providers '(("kimi" . my/llm-provider-kimi)
                             ("gpu" . my/llm-provider-gpu)
                             ("deepseek-v2.5" . my/llm-provider-deepseek)))
  ;; (setopt ellama-naming-provider my/llm-provider)
  (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
  ;; (setopt ellama-translation-provider my/llm-provider)
  (setopt ellama-keymap-prefix "C-c i a")
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
  (define-key ellama-command-map (kbd "c d") #'my/ellama-code-generate-comment)
  )
(provide 'init-openai)
