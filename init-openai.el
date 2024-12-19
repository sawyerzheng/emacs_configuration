
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

(my/straight-if-use '(llm :type git :host github :repo "ahyatt/llm" :files ("*.el" "**/*.el")))
(use-package llm
  :defer t
  :config
  (my/elisp-load-file-existsp "~/org/private/gptel-setup.el")
  )

(my/straight-if-use '(ellama :type git :host github :repo "s-kostyaev/ellama"))
;; (when (file-exists-p (locate-library "ellama-autoloads"))
;;   (require 'ellama-autoloads))

(use-package ellama
  :bind (("C-c i a" . ellama-transient-main-menu))
  :init
  (require 'llm)
  (setq ellama-sessions-directory (expand-file-name "ellama-sessions" no-littering-var-directory))
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
  )

(provide 'init-openai)
