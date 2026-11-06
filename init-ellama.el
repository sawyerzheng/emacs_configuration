;;; init-ellama.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025
;;
;; Author:  <sawyer@jishutest>
;; Maintainer:  <sawyer@jishutest>
;; Created: July 22, 2025
;; Modified: July 22, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/sawyerzheng/init-ellama
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
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
  (setq ellama-generate-commit-message-template
        (with-temp-buffer
          (let ((coding-system-for-read 'utf-8))
            (insert-file-contents
             (expand-file-name "./custom.d/prompts/ellama-commit-prompt-template.md"
                               my/conf-distro-dir))
            (buffer-string))))

  (require 'llm)
  (if my/doom-p
      (setq ellama-sessions-directory (expand-file-name "ellama-sessions" doom-data-dir))
    (setq ellama-sessions-directory (expand-file-name "ellama-sessions" no-littering-var-directory)))


  (setopt ellama-language "汉语")
  ;; could be llm-openai for example
  (setopt ellama-provider my/llm-provider-deepseek-chat)
  (setopt ellama-providers
          (list (cons "kimi" my/llm-provider-kimi)
                (cons "gpu" my/llm-provider-gpu)
                ;; (cons "siliconflow-deepseek-v3" my/llm-provider-siliconflow-deepseek-v3)
                ;; (cons "siliconflow-deepseek-r1" my/llm-provider-siliconflow-deepseek-r1)
                (cons "deepseek-chat" my/llm-provider-deepseek-chat)
                (cons "deepseek-reasoner" my/llm-provider-deepseek-reasoner)
                (cons "ollama-deepseek-r1" my/llm-provider-ollama-deepseek-r1)
                (cons "ollama-deepseek-r1-office" my/llm-provider-ollama-deepseek-r1-office)
                (cons "ollama-qwen2.5-coder" my/llm-provider-ollama-qwen2.5-coder)
                (cons "ollama-qwen2.5-coder-office" my/llm-provider-ollama-qwen2.5-coder-office)
                (cons "ollama-qwen2.5-chat" my/llm-provider-ollama-qwen2.5-chat)
                (cons "ollama-qwen2.5-chat-office" my/llm-provider-ollama-qwen2.5-chat-office)
                (cons "openrouter-nemo3ultra-free" my/llm-provider-openrouter-nemo3ultra-free)
                (cons "lightllm-deepseek-v4-flash" my/llm-provider-lightllm-deepseek-v4-flash)))

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


  ;; 只隐藏 ellama 自己的 context posframe，避免误删其他包的 posframe
  (defun my/ellama-ask-command-advice-fn (&rest _args)
    "Hide ellama's context posframe after `ellama-ask-about'."
    (when (and (bound-and-true-p ellama-context-posframe-enabled)
               (boundp 'ellama--context-buffer)
               (fboundp 'posframe-hide))
      (ignore-errors (posframe-hide ellama--context-buffer))))
  (advice-add #'ellama-ask-about :after #'my/ellama-ask-command-advice-fn)
  )



(provide 'init-ellama)
;;; init-ellama.el ends here
