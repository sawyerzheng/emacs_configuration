(require 'json)
(require 'plz)

(defvar codegeex-api-key "68cf004321e94b47a91c2e45a8109852"
  "API key for codegeex.")

(defvar codegeex-api-secret "e82b86a16f9d471ab215f653060310e3"
  "API secret for codegeex.")

(defvar codegeex-request-url "https://tianqi.aminer.cn/api/v2/"
  "URL for codegeex API.")

(defvar codegeex-api "multilingual_code_generate"
  "API method for codegeex.")

(defcustom codegeex-lang-alist
  '(
    (c-mode . "c")
    (c++-mode . "cpp")
    (python-mode . "python")
    (java-mode . "java")
    (tex-mode . "TeX")
    (html-mode . "HTML")
    (typescript-mode . "TypeScript")
    (go-mode . "Go")
    (shell-script-mode . "Shell"))
  "major-mode -- language id mapping alist"
  ;; :group 'codegeex
  ;; :type '(repeat
  ;;         (cons
  ;;          (symbol "Major mode")
  ;;          (string "Language name")))
  )

(defun codegeex--get-lang-id ()
  (alist-get major-mode codegeex-lang-alist))

(defun codegeex--parse (resp-alist)
  "output is a vector of string, eg: [\"yes\", \"no\"]"
  (let* ((options
          (thread-last resp-alist
                       (assoc-default 'result)
                       (assoc-default 'output)
                       (assoc-default 'code))))
    (append (vconcat options) nil)))

(defun handle-json-response (status response &optional callback)
  "Handle JSON response from `request` function."
  (let ((json-object-type 'hash-table))
    (setq response (json-read-from-string response))
    ;; handle the JSON data here
    (if callback (funcall callback response))))

(defun codegeex--make-request (prompt number lang)
  (let* ((headers '(("Content-Type" . "application/json")))
         (data `(("apikey" . ,codegeex-api-key)
                 ("apisecret" . ,codegeex-api-secret)
                 ("prompt" . ,prompt)
                 ("n" . ,number)
                 ("lang" . ,lang)))
         options
         (response
          (plz 'post (concat codegeex-request-url codegeex-api)
            :headers headers
            :body (json-encode data)
            :as #'json-read)

          ;; (request (concat codegeex-request-url codegeex-api)
          ;;   :type "POST"
          ;;   :headers headers
          ;;   :data (json-encode data)
          ;;   :parser #'json-read
          ;;   :sync t
          ;;   :success (cl-function
          ;;             (lambda (&key data &allow-other-keys)
          ;;               (setq options data)))
          ;;   :error (cl-function
          ;;           (lambda (&key error-thrown &allow-other-keys)
          ;;             (message "Request failed: %S" error-thrown))))
          )
         )
    ;; options
    response))

(defun codegeex--make-request (prompt number lang)
  (let* ((headers '(("Content-Type" . "application/json")))
         (data `(("apikey" . ,codegeex-api-key)
                 ("apisecret" . ,codegeex-api-secret)
                 ("prompt" . ,prompt)
                 ("n" . ,number)
                 ("lang" . ,lang)))
         options
         (response
          ;; (plz 'post (concat codegeex-request-url codegeex-api)
          ;;   :headers headers
          ;;   :body (json-encode data)
          ;;   :as #'json-read)

          (request (concat codegeex-request-url codegeex-api)
            :type "POST"
            :headers headers
            :data (json-encode data)
            :parser #'json-read
            :sync t
            :success (cl-function
                      (lambda (&key data &allow-other-keys)
                        (setq options data)))
            :error (cl-function
                    (lambda (&key error-thrown &allow-other-keys)
                      (message "Request failed: %S" error-thrown))))
          )
         )
    options;; response
    ))

(defun codegeex--get-text-before-point ()
  "Return the text between the start of the buffer and the point."
  (buffer-substring-no-properties (save-excursion (forward-line -50) (point)) (point)))



(defvar codegeex-completion-timer nil
  "Timer used to delay codegeex API requests.")

(defvar codegeex-completion-delay 2
  "Delay in seconds before sending codegeex API requests.")

(defvar codegeex-current-completion nil
  "Current codegeex completion.")

;; (defun codegeex-request-completion ()
;;   "Send a codegeex API request based on the text before point."
;;   (interactive)
;;   (let* ((prompt (codegeex--get-text-before-point))
;;          (response (codegeex--make-request prompt 10 "python"))
;;          (options (codegeex--parse response)))
;;     (setq codegeex-current-completion options)
;;     (if (eq this-command 'codegeex-request-completion)
;;         (when options
;;           (let ((comp (completing-read "Codegeex completion: " options)))
;;             (insert comp)))
;;       (progn
;;         (let* (start
;;                end
;;                (bounds (bounds-of-thing-at-point 'symbol)))
;;           (if bounds
;;               (setq start (- (car bounds) 1)
;;                     end (cdr bounds))
;;             (setq start (point)
;;                   end (point)))
;;           (list
;;            start
;;            end
;;            options
;;            :exclusive 'no))))))

(defun codegeex--request-completion ()
  "Send a codegeex API request based on the text before point."
  (let* ((prompt (codegeex--get-text-before-point))
         (lang (codegeex--get-lang-id))
         (response)
         (options))
    (when lang
      (setq response (codegeex--make-request prompt 10 lang))
      (setq options (codegeex--parse response)))
    options))

;;;###autoload
(defun codegeex-request-completion ()
  "Send a codegeex API request based on the text before point."
  (interactive)
  (when-let* ((options (codegeex--request-completion)))
    (setq codegeex-current-completion options)
    (when options
      (let ((comp (completing-read "Codegeex completion: " options)))
        (insert comp)))))


(defun codegeex-completion-at-point ()
  "Send a codegeex API request based on the text before point."
  (let* ((options (codegeex--request-completion))
         start
         end
         (bounds (bounds-of-thing-at-point 'symbol)))
    (if bounds
        (setq start (- (car bounds) 1)
              end (cdr bounds))
      (setq start (point)
            end (point)))
    (when options
      (list start
            end
            options
            :exclusive 'no)))
  ;; (async-start
  ;;  #'codegeex--request-completion
  ;;  (lambda (options)

  ;;    )
  ;;  )
  )

(defun codegeex-start-completion-timer ()
  "Start the completion timer if not already started."
  (unless codegeex-completion-timer
    (setq codegeex-completion-timer
          (run-with-idle-timer codegeex-completion-delay nil #'codegeex-request-completion))))

(defun codegeex-stop-completion-timer ()
  "Stop the completion timer if running."
  (when codegeex-completion-timer
    (cancel-timer codegeex-completion-timer)
    (setq codegeex-completion-timer nil)))

;;;###autoload
(defun codegeex-setup-completion ()
  "Setup codegeex completion for the current buffer."
  (interactive)
  (add-hook 'post-command-hook #'codegeex-start-completion-timer nil t)
  (add-hook 'pre-command-hook #'codegeex-stop-completion-timer nil t))

;;;###autoload
(defun codegeex-teardown-completion ()
  "Teardown codegeex completion for the current buffer."
  (interactive)
  (remove-hook 'post-command-hook #'codegeex-start-completion-timer t)
  (remove-hook 'pre-command-hook #'codegeex-stop-completion-timer t))

;;;###autoload
(define-minor-mode codegeex-mode
  "codegeex minor mode"
  :lighter "CodeGeex"
  :keymap (let* ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-i") #'codegeex-request-completion)
            map)
  (if codegeex-mode
      (codegeex-setup-completion)
    (codegeex-teardown-completion)))
