(provide 'init-comingle)

(defvar my/comingle-is-enabled t)
(use-package comingle
  ;;:ensure t
  ;;:straight '(:type git :host github :repo "jeff-phil/comingle.el")
  ;;:vc (:fetcher github :repo "jeff-phil/comingle.el" :rev "main")
  :commands (my/comingle-toggle comingle-mode)
  :bind
  (("s-<return>" . comingle-accept-completion)
   ("S-<return>" . comingle-accept-completion-line)
   ("M-<return>" . comingle-accept-completion-word)
   ("C-<return>" . comingle-accept-completion-character)
   ("H-j" . comingle-next-completion)
   ("H-k" . comingle-prev-completion)
   ("H-C" . 'my/comingle-toggle)
   ("C-c p c" . comingle-chat-open)) ;;  launch chat
  :hook (prog-mode . my/try-run-comingle-mode)
  :init
  ;; optionally set a timer, which might speed up things as the
  ;; comingle local language server takes ~0.2s to start up
  (when (bound-and-true-p my/comingle-is-enabled)
    (add-hook 'emacs-startup-hook
              (lambda ()
                (run-with-timer
                 0.1
                 nil
                 (lambda ()
                   (when (comingle-state-proc comingle-state)
                     ;; temporarily disable comingle, so that we can init
                     (let ((my/comingle-is-enabled nil))
                       (my/comingle-toggle))))))))
  :config
  (defun my/try-run-comingle-mode ()
    "Use in hook, like prog-mode-hook, so that can test first if comingle is enabled."
    (when (bound-and-true-p my/comingle-is-enabled)
      (comingle-mode)))

  (defun my/comingle-toggle (&optional state)
    "Toggle comingle's enabled state."
    (interactive)
    (let ((current-state (or state comingle-state)))
      (cond
       ;; First condition: Is comingle currently enabled?
       (my/comingle-is-enabled
         (when (and current-state (comingle-state-proc current-state))
           ;; -> Then, disable it. No `progn` needed.
           (comingle-reset))
        (setq my/comingle-is-enabled nil)
        (message "Comingle disabled"))
       ;; if you don't want to use customize to save the api-key
       (t (setopt comingle/metadata/api_key
                  `,(auth-source-pass-get 'secret "ai/api_key@codeium.com"))
          ;; Reset only if it was already in a valid (but not running) state
          (when current-state
            (comingle-reset))
          (comingle-init)
          (setq my/comingle-is-enabled t)
          (message "Comingle enabled")))))

  (setq use-dialog-box nil) ;; do not use popup boxes

  ;; get comingle status in the modeline
  (setq comingle-mode-line-enable
        (lambda (api)
          (when (bound-and-true-p my/comingle-is-enabled)
            (not (memq api '(CancelRequest Heartbeat AcceptCompletion))))))
  (add-to-list 'mode-line-format '(:eval (car-safe comingle-mode-line)) t)
  ;; alternatively for a more extensive mode-line
  ;; (add-to-list 'mode-line-format '(-50 "" comingle-mode-line) t)

  ;; You can overwrite all the comingle configs!
  ;; for example, we recommend limiting the string sent to comingle for better perf
  (defun my/comingle/document/text ()
    (buffer-substring-no-properties
     (max (- (point) 3000) (point-min))
     (min (+ (point) 1000) (point-max))))
  ;; if you change the text, you should also change the cursor_offset
  ;; warning: this is measured by UTF-8 encoded bytes
  (defun my/comingle/document/cursor_offset ()
    (comingle-utf8-byte-length
     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
  (setq comingle/document/text 'my/comingle/document/text)
  (setq comingle/document/cursor_offset 'my/comingle/document/cursor_offset))
