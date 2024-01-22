(require 'plz)
(require 'polymode)


(define-error 'my/chatgpt-interface-parsing-error
  "An error when parsing OpenAI API Response")

(defgroup my/chatgpt-interface nil
  "group for my/chatgpt-interface library"
  :prefix "my/chatgpt-interface-"
  :group 'text)

(defcustom my/chatgpt-interface-use-code-blocks t
  "if use code blocks for anwser and use polymode"
  :group 'my/chatgpt-interface
  :type 'boolean)


(defcustom my/chatgpt-interface-api-url-type-model-alist
  '((v1-completion . ("text-davinci-003" "code-davinci-002"))
    (v1-chat-completion . ("gpt-3.5-turbo")))
  "http api and its support models alist"
  :group 'my/chatgpt-interface
  :type '(repeat
          (cons
           (string "api url")
           (repeat string))))

(defcustom my/chatgpt-interface-api-url-resp-parser-alist
  '(("https://api.openai.com/v1/completions" . #'my/chatgpt-interface--parse-v1-completion-resonse)
    ("https://api.openai.com/v1/chat/completions" . #'my/chatgpt-interface--parse-chat-completion-response))
  "http api and its support models alist"
  :group 'my/chatgpt-interface
  :type '(repeat
          (cons
           (string "api url")
           (symbol "function name"))))

(defcustom my/chatgpt-interface-action-param-alist
  '(("fix" . (("temperature" . 0)
              ("model" . "code-davinci-002")))
    )
  ""
  :group 'my/chatgpt-interface)


(defcustom my/chatgpt-interface-action-default-model "code-davinci-002"
  ""
  :group 'my/chatgpt-interface
  :type 'string)

(defun my/chatgpt-interface--get-param (model &optional action)
  (let* ((url (my/chatgpt-interface--get-api-url-type model))
         (temperature my/chatgpt-interface-temperature))))

(defcustom my/chatgpt-interface-mode-lang-alist
  '((emacs-lisp-mode . "elisp")
    (artist-mode . "ditaa")
    (fundamental-mode . "dot")
    (sql-mode . "sqlite")
    (fundamental-mode . "calc")
    (c-mode . "c")
    (c++-mode . "cpp")
    (sh-mode . "sh")
    (python-mode . "python")
    (java-mode . "java"))
  "major-mode -- language id mapping alist"
  :group 'my/chatgpt-interface
  :type '(repeat
          (cons
           (symbol "Major mode")
           (string "Language name"))))

(defcustom my/chatgpt-interface-code-action '("fix" "improve" "test" "completion")
  "chatgpt code actions"
  :group 'my/chatgpt-interface
  :type '(repeat string))


(defcustom my/chatgpt-interface-buffer "*ChatGPT Mine*"
  "buffer name to display query result"
  :type 'string)

(defcustom my/chatgpt-interface-temperature 0
  "temperature paramter for openai completion api"
  :type 'number)

(defcustom my/chatgpt-interface-max-tokens 200
  "max-tokens paramter for openai completion api"
  :type 'integer)

(defcustom my/chatgpt-interface-model "text-davinci-003"
  "model to use"
  :type 'string)

(defcustom my/chatgpt-interface-action-alist
  '(("custom" . "Write your own instruction")
    ("doc" . "Automatically write documentation for your code")
    ("fix" . "Find problems with it")
    ("explain" . "Explain the selected code")
    ("improve" . "Please improve the following.")
    ("completion" . "completion code with following demands:")
    )
  "predefined code actions for chatgpt"
  :type '(repeat (cons
                  (string "action name")
                  (string "action value used as prompt to chatgpt"))))


(defun my/chatgpt-interface--get-api-url-type (model)
  (let (api
        seleted-api)
    (dolist (api-cons my/chatgpt-interface-api-url-type-model-alist)
      (setq api (car api-cons))
      (if (member model (cdr api-cons))
          (setq seleted-api api)))
    seleted-api))

(defun my/chatgpt-interface--query (prompt)
  (let* (resp
         (auth (concat "Bearer " openai-key)))
    (setq resp (plz 'post "https://api.openai.com/v1/completions"
                 :headers `(("Content-Type" . "application/json")
                            ("Authorization" . ,auth))
                 :body (json-encode `(("model" . ,my/chatgpt-interface-model)
                                      ("prompt" . ,prompt)
                                      ("max_tokens" . ,my/chatgpt-interface-max-tokens)
                                      ("temperature" . ,my/chatgpt-interface-temperature)))
                 :as #'json-read))
    (my/chatgpt-interface--parse-v1-completion-resonse resp)))

(defun my/chatgpt-interface--parse-v1-completion-resonse (resp-alist)
  (condition-case err
      (thread-last resp-alist
                   (assoc-default 'choices)
                   seq-first
                   (assoc-default 'text)
                   string-trim)
    (error
     (signal 'my/chatgpt-interface-parsing-error err))))

(defun my/chatgpt-interface--parse-chat-turbo-mode-response (resp-alist)
  (thread-last resp-alist
               (assoc-default 'choices)
               seq-first
               (assoc-default 'message)
               (assoc-default 'content)
               string-trim))

(defun my/chatgpt-interface--write-output (output)
  (with-current-buffer (get-buffer-create my/chatgpt-interface-buffer)
    (read-only-mode -1)
    ;; (erase-buffer)
    (insert (format "Answer:\n%s\n" output))
    (insert ?\f)
    (page-break-lines-mode 1)
    (visual-line-mode 1)
    (read-only-mode 1))
  (unless (get-buffer-window my/chatgpt-interface-buffer)
    (switch-to-buffer-other-window my/chatgpt-interface-buffer)))

;;;###autoload
(defun my/chatgpt-interface-prompt (prompt)
  (interactive (list (read-string "Prompt ChatGPT with: ")))

  (let* (results)
    (setq results (my/chatgpt-interface--query prompt))
    (with-current-buffer (get-buffer-create my/chatgpt-interface-buffer)
      (read-only-mode -1)
      (erase-buffer)
      (insert results)
      (switch-to-buffer-other-window my/chatgpt-interface-buffer))))

;;;###autoload
(defun my/chatgpt-interface-async-prompt (prompt &optional model)
  (interactive (list (read-string "Prompt ChatGPT with: ")))
  (unless model
    (setq model my/chatgpt-interface-model))
  (my/chatgpt-interface--async-query prompt model))

;;;###autoload
(defun my/chatgpt-interface-prompt-region (&optional arg)
  (interactive "P")
  (let (start end text)
    (if (region-active-p)
        (progn
          (setq start (region-beginning)
                end (region-end))
          (deactivate-mark)
          (setq text (buffer-substring-no-properties (region-beginning) (region-end)))
          (if arg
              (my/chatgpt-interface--query-region text)
            (my/chatgpt-interface--async-query text my/chatgpt-interface-model)))
      (call-interactively #'my/chatgpt-interface-async-prompt))))

(defun my/chatgpt-interface--query-region (text)
  (let* ((begin (region-beginning))
         (end (region-end))
         (buff (current-buffer)))
    (save-excursion
      (save-current-buffer
        (set-buffer buff)
        (delete-region begin end)
        (goto-char begin)
        (insert (my/chatgpt-interface--query text))))))

;;;###autoload
(defun my/chatgpt-interface-prompt-region-action (&optional arg)
  (interactive "P")
  (let* (prompt
         (action-alist my/chatgpt-interface-action-alist)
         (action-key (completing-read
                      "choose action:" (mapcar #'car action-alist)))
         (action-value (cdr
                        (assoc action-key action-alist)))
         (model my/chatgpt-interface-action-default-model)
         start
         end)
    (if (region-active-p)
        (progn
          (if (equal action-key "custom")
              (my/chatgpt-interface--async-query
               (format "%s\n\n%s\n"
                       (read-string "Prompt ChatGPT with: ")
                       (buffer-substring (region-beginning) (region-end)))
               my/chatgpt-interface-action-default-model)
            (setq prompt (format "%s\n\n%s\n" action-value (buffer-substring (region-beginning) (region-end))))
            (my/chatgpt-interface--async-query prompt model)))
      (my/chatgpt-interface--async-query
       (read-string "Prompt ChatGPT with: ")
       my/chatgpt-interface-action-default-model))))


(define-auto-innermode my/chatgpt-interface-pm-auto-innermode
  :head-matcher (cons "^\\(```[ \t]*{?[[:alpha:]]+}?\\)[ \t]*$" 1)
  :tail-matcher (cons "^\\(```\\)[ \t]*$" 1)
  :mode-matcher (cons "^```[ \t]*{?\\([[:alpha:]]+\\)}?[ \t]*$" 1)
  :head-mode 'host
  :tail-mode 'host)

(define-innermode my/chatgpt-interface-pm-unknown-innermode
  :mode 'host
  :head-matcher (cons "^\\(```\\)[ \t]*$" 1)
  :tail-matcher (cons "^\\(```\\)[ \t]*$" 1)
  :head-mode 'host
  :tail-mode 'host)


;;;###autoload
(define-polymode my/chatgpt-interface-pm-mode
  :hostmode 'poly-fundamental-hostmode
  :innermodes '(
                ;; my/chatgpt-interface-python-innermode
                my/chatgpt-interface-pm-unknown-innermode
                my/chatgpt-interface-pm-auto-innermode
                ))

(defun my/chatgpt-interface--get-lang-id ()
  (alist-get major-mode my/chatgpt-interface-mode-lang-alist))


(defun my/chatgpt-interface--check-prompt-type (prompt &optional is-action)
  "check prompt action type with prompt start with substring"
  (let ((id nil)
        action
        action-pair
        action-value)
    (dolist (action-pair my/chatgpt-interface-action-alist)
      (setq action (car action-pair)
            action-value (cdr action-pair))
      (when (and (string-prefix-p action-value prompt) (member action my/chatgpt-interface-code-action))
        (setq id (my/chatgpt-interface--get-lang-id))))
    id))

(defun my/chatgpt-interface--output-wrap-as-code-block (lang-id output)
  (if lang-id
      (format "``` %s\n%s\n```\n" lang-id output)
    output))

(defun my/chatgpt-interface--async-query (prompt model)
  "This function is used to query the OpenAI API for a response to a given prompt,
 and save question and output in `my/chatgpt-interface-buffer' when got response."
  (if (string-empty-p openai-key)
      (user-error " [INFO] no openai key, please load it correctly as string" openai-key)
    (let* ((api-url-type (my/chatgpt-interface--get-api-url-type model))
           (auth (concat "Bearer " openai-key))
           (temperature my/chatgpt-interface-temperature)
           (max_tokens my/chatgpt-interface-max-tokens))
      (cond
       ((eq api-url-type 'v1-chat-completion)
        (my/chatgpt-interface--make-v1-chat-completion-response prompt model auth max_tokens temperature))
       ((eq api-url-type 'v1-completion)
        (my/chatgpt-interface--make-v1-competion-respone prompt model auth max_tokens temperature))
       (t
        (message "unkown api url type"))))))

(defun my/chatgpt-interface--parse-v1-chat-completion-response (resp-alist)
  (thread-last resp-alist
               (assoc-default 'choices)
               seq-first
               (assoc-default 'message)
               (assoc-default 'content)
               string-trim))

(defun my/chatgpt-interface--resp-output-writer (prompt output lang-id)
  (when my/chatgpt-interface-use-code-blocks
    (setq output (my/chatgpt-interface--output-wrap-as-code-block lang-id output)))
  (with-current-buffer (get-buffer-create my/chatgpt-interface-buffer)
    (read-only-mode -1)
    (goto-char (point-max))
    (insert (format "Question:\n%s\n\n" prompt))
    (save-excursion
      (my/chatgpt-interface--write-output output))
    (read-only-mode 1)
    (when my/chatgpt-interface-use-code-blocks
      (my/chatgpt-interface-pm-mode 1))))

(defun my/chatgpt-interface--make-v1-competion-respone (prompt model auth max_tokens temperature)
  (let* ((api-url "https://api.openai.com/v1/completions")
         (lang-id (my/chatgpt-interface--check-prompt-type prompt)))
    (eval `(plz 'post ,api-url
             :headers '(("Content-Type" . "application/json")
                        ("Authorization" . ,auth))
             :body (json-encode '(("model" . ,model)
                                  ("prompt" . ,prompt)
                                  ("max_tokens" . ,max_tokens)
                                  ("temperature" . ,temperature)))
             :as #'json-read
             :then (lambda (resp)
                     (setq output (my/chatgpt-interface--parse-v1-completion-resonse resp))
                     (my/chatgpt-interface--resp-output-writer ,prompt output ,lang-id))))))

(defun my/chatgpt-interface--make-v1-chat-completion-response (prompt model auth max_tokens temperature &optional system-content-opt)
  (let* ((system-content (if system-content-opt system-content-opt "You are an assistant."))
         (lang-id (my/chatgpt-interface--check-prompt-type prompt)))
    (eval `(plz 'post "https://api.openai.com/v1/chat/completions"
             :headers '(("Content-Type" . "application/json")
                        ("Authorization" . ,auth))
             :body (json-encode '(("model" . "gpt-3.5-turbo")
                                  ("messages" . [(("role" . "system")
                                                  ("content" . ,system-content))
                                                 (("role" . "user")
                                                  ("content" . ,prompt))])
                                  ("max_tokens" . ,max_tokens)
                                  ("temperature" . ,temperature)))
             :as #'json-read
             :then (lambda (resp)
                     (setq output (my/chatgpt-interface--parse-v1-chat-completion-response resp))
                     (my/chatgpt-interface--resp-output-writer ,prompt output ,lang-id))))))

(provide 'my-chatgpt-interface)
