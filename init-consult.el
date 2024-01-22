(use-package consult
  :straight t
  ;; :after (project projectile)
  :commands (consult-line +default/search-buffer)
  :bind
  (([remap recentf-open-files] . consult-recent-file)
   ("C-c f r" . consult-recent-file)
   ("C-c f f" . consult-find)

   ("C-c o e" . consult-file-externally)

   ("C-c s s" . +default/search-buffer) ;; use `consult-line' as backend
   ("C-c s p" . consult-ripgrep)
   ("C-c s g" . consult-git-grep)
   ("C-c s f" . consult-find)
   ("C-c s i" . consult-imenu) ;; search items (function, class) with imenu
   ("C-c s I" . consult-imenu-multi) ;; imenu in all project buffers

   ("C-c b b" . consult-buffer)
   ("C-c b i" . consult-imenu)
   ("C-h t" . consult-theme)
   ("C-h C-t" . consult-theme)

   ;; ("C-c o e" . consult-file-externally)

   ;; * buffer switch
   ;; any
   ([remap switch-to-buffer] . consult-buffer)
   ;; in project
   ([remap projectile-switch-to-buffer] . consult-project-buffer)

   ([remap goto-line] . consult-goto-line)

   ;; C-c bindings (mode-specific-map)
   ;; ("C-c h" . consult-history)
   ("C-c m" . consult-mode-command)
   ("C-c k" . consult-kmacro)
   ;; C-x bindings (ctl-x-map)
   ("C-x M-:" . consult-complex-command) ;; orig. repeat-complex-command
   ;; ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
   ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
   ("C-x 5 b" . consult-buffer-other-frame) ;; orig. switch-to-buffer-other-frame
   ("C-x r b" . consult-bookmark)           ;; orig. bookmark-jump
   ;; ("C-x p b" . consult-project-buffer) ;; orig. project-switch-to-buffer
   ;; Custom M-# bindings for fast register access
   ;; ("M-#" . consult-register-load)
   ;; ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
   ("C-M-#" . consult-register)
   ;; Other custom bindings
   ("M-y" . consult-yank-pop)     ;; orig. yank-pop
   ("<help> a" . consult-apropos) ;; orig. apropos-command
   ;; M-g bindings (goto-map)
   ("M-g e" . consult-compile-error)
   ("M-g f" . consult-flymake)     ;; Alternative: consult-flycheck
   ("M-g g" . consult-goto-line)   ;; orig. goto-line
   ("M-g M-g" . consult-goto-line) ;; orig. goto-line
   ("M-g o" . consult-outline)     ;; Alternative: consult-org-heading
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-imenu-multi)
   ;; M-s bindings (search-map)
   ("M-s d" . consult-find)
   ("M-s D" . consult-locate)
   ("M-s g" . consult-grep)
   ("M-s G" . consult-git-grep)
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)
   ("M-s m" . consult-multi-occur)
   ("M-s k" . consult-keep-lines)
   ("M-s u" . consult-focus-lines)
   ;; Isearch integration
   ("M-s e" . consult-isearch-history)
   :map isearch-mode-map
   ("M-e" . consult-isearch-history)   ;; orig. isearch-edit-string
   ("M-s e" . consult-isearch-history) ;; orig. isearch-edit-string
   ("M-s l" . consult-line) ;; needed by consult-line to detect isearch
   ("M-s L" . consult-line-multi) ;; needed by consult-line to detect isearch
   ;; Minibuffer history
   :map minibuffer-local-map
   ("M-s" . consult-history) ;; orig. next-matching-history-element
   ("M-r" . consult-history))
  :init
  ;; copy and modified code from doom-emacs
  (defun +default/search-buffer ()
    "Conduct a text search on the current buffer.

If a selection is active and multi-line, perform a search restricted to that
region.

If a selection is active and not multi-line, use the selection as the initial
input and search the whole buffer for it."
    (interactive)
    (let (start end multiline-p)
      (save-restriction
        (when (region-active-p)
          (setq start (region-beginning)
                end (region-end)
                multiline-p (/= (line-number-at-pos start)
                                (line-number-at-pos end)))
          (deactivate-mark)
          (when multiline-p
            (narrow-to-region start end)))
        (if (and start end (not multiline-p))
            (consult-line
             (replace-regexp-in-string
              " " "\\\\ "
              (rxt-quote-pcre
               (buffer-substring-no-properties start end))))
          (call-interactively #'consult-line)))))

  (defun consult-file-externally (file)
    "Open FILE using system's default application."
    (interactive "fOpen externally: ")
    (if (and (eq system-type 'windows-nt)
             (fboundp 'w32-shell-execute))
        (w32-shell-execute "open" file)
      (call-process (pcase system-type
                      ('darwin "open")
                      ('cygwin "cygstart")
                      (_ "xdg-open"))
                    nil 0 nil
                    (expand-file-name file))))

  ;; integration with xref
  (setq xref-show-xrefs-function #'consult-xref)
  (setq xref-show-definitions-function #'consult-xref)

  :config
  ;; enable consult ripgrep at point
  (consult-customize consult-ripgrep
                     :initial (consult--async-split-initial (thing-at-point 'symbol)))
  (setq consult-async-min-input 2))



(use-package window
  :straight (:type built-in)
  :bind (("C-c b x" . my/switch-to-scratch-fn)
         ("C-c b p" . switch-to-prev-buffer)
         ("C-c b n" . switch-to-next-buffer))
  :init
  (defun my/switch-to-scratch-fn ()
    (interactive) (switch-to-buffer "*scratch*")))

(use-package files
  :straight (:type built-in)
  :bind
  ("C-c b r" . revert-buffer)
  ("C-c b s" . save-buffer))

(use-package frame
  :straight (:type built-in)  
  :bind
  ("C-c o f" . make-frame-command))


(use-package consult-yasnippet
  :straight t
  :commands (consult-yasnippet
             consult-yasnippet-visit-snippet-file))

(use-package consult-dir
  :straight t
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

(use-package consult-tramp
  :straight (:type git :host github :repo "Ladicle/consult-tramp")
  :commands (consult-tramp))


;; consult-fd
(with-eval-after-load 'consult
  (defvar consult--fd-command nil)
  (defun consult--fd-builder (input)
    (unless consult--fd-command
      (setq consult--fd-command
            (if (eq 0 (call-process-shell-command "fdfind"))
                "fdfind"
              "fd")))
    (pcase-let* ((`(,arg . ,opts) (consult--command-split input))
                 (`(,re . ,hl) (funcall consult--regexp-compiler
                                        arg 'extended t)))
      (when re
        (list :command (append
                        (list consult--fd-command
                              "--color=never" "--full-path"
                              (consult--join-regexps re 'extended))
                        opts)
              :highlight hl))))

  (defun consult-fd (&optional dir initial)
    (interactive "P")
    (let* ((prompt-dir (consult--directory-prompt "Fd" dir))
           (default-directory (cdr prompt-dir)))
      (find-file (consult--find (car prompt-dir) #'consult--fd-builder initial))))
  (global-set-key (kbd "M-s f") #'consult-fd))

(provide 'init-consult)
