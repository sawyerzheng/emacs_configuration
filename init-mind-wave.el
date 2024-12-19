(my/straight-if-use '(mind-wave :type git :host github :repo "manateelazycat/mind-wave" :files ("*")))

(use-package mind-wave
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

(provide 'init-mind-wave)
