;; -*- coding: utf-8; -*-
(add-to-list 'load-path  (expand-file-name "acm" (file-name-directory (locate-library "lsp-bridge"))))
(use-package acm-terminal
  ;; :if (and (daemonp) (not (display-graphic-p)))
  :if (not (display-graphic-p))
  :init

  (defun my/acm-terminal-set-colors ()
    "set acm terminal face color"
    (interactive)
    (unless (fboundp #'acm-terminal-init-colors)
      (require 'acm-terminal))
    (acm-terminal-init-colors t) ;; force blend color
    )
  (defun my/acm-terminal-enable ()
    (interactive)
    (acm-terminal-active))
  (defun my/acm-terminal-disable ()
    (interactive)
    (acm-terminal-deactive))
  (defun my/acm-terminal-make-frame-auto-switch ()
    (with-eval-after-load 'acm-terminal
      (when (daemonp)
	(if (display-graphic-p)
            (acm-terminal-deactive)
	  (acm-terminal-active)
	  ))))
  ;; (add-to-list 'after-make-frame-functions #'my/acm-terminal-make-frame-auto-switch)
  ;; :hook (lsp-bridge-mode . my/acm-terminal-make-frame-auto-switch)
  :config

  (defun acm-terminal-init-colors (&optional force)
    (let* ((is-dark-mode (string-equal (acm-frame-get-theme-mode) "dark"))
           (blend-background (if is-dark-mode "#555555" "#AAAAAA"))
           (default-background (acm-terminal-default-background)))
      ;; Make sure menu follow the theme of Emacs.
      (when (or force (equal (face-attribute 'acm-terminal-default-face :background) 'unspecified))
        (set-face-background 'acm-terminal-default-face (acm-frame-color-blend default-background blend-background (if is-dark-mode 0.8 0.9))))
      (when (or force (equal (face-attribute 'acm-terminal-select-face :background) 'unspecified))
        (set-face-background 'acm-terminal-select-face (acm-frame-color-blend default-background blend-background 0.6)))
      (when (or force (equal (face-attribute 'acm-terminal-select-face :foreground) 'unspecified))
        (set-face-foreground 'acm-terminal-select-face (face-attribute 'font-lock-function-name-face :foreground)))))
  :hook (lsp-bridge-mode . my/acm-terminal-set-colors)
  :after lsp-bridge)

(use-package lsp-bridge
  :commands (lsp-bridge-rename lsp-bridge-mode global-lsp-bridge-mode)
  ;; :hook (my/startup . global-lsp-bridge-mode)
  ;; :hook ((emacs-lisp-mode
  ;; lisp-interaction-mode) . lsp-bridge-mode)
  :bind (:map lsp-bridge-mode-map
              ("M-." . lsp-bridge-find-def)
              ("M-," . lsp-bridge-find-def-return)
              ("M-*" . lsp-bridge-peek)
              ("M-?" . lsp-bridge-find-references)
              ("C-M-." . lsp-bridge-popup-documentation-scroll-up)
              ("C-M-," . lsp-bridge-popup-documentation-scroll-down)
              ("C-M-I" . lsp-bridge-popup-complete-menu)
              ("M-i" . lsp-bridge-popup-complete-menu))
  :bind (:map acm-mode-map
              ("TAB" . acm-select-next)
              ("<tab>" . acm-select-next)
              ("<backtab>" . acm-select-prev)
              ("S-<tab>" . acm-select-prev)
              ("M-h" . acm-doc-toggle)
              ("M-I" . acm-doc-scroll-up)
              ("M-K" . acm-doc-scroll-down)
              ("M-k" . acm-doc-scroll-up)
              ("M-j" . acm-doc-scroll-down)
              ("<return>" . acm-complete)
              ([remap newline] . acm-complete)
              ("RET" . acm-complete)
              )
  :custom
  (lsp-bridge-enable-signature-help t)

  :config

  (setq lsp-bridge-mode-lighter " 橋")
  (setq lsp-bridge-mode-lighter " 🚀")

  (require 'lsp-bridge-peek)
  ;; peek
  (define-key lsp-bridge-peek-keymap (kbd "M-t") #'lsp-bridge-peek-through)
  ;; inlay hint
  (set-face-attribute 'lsp-bridge-inlay-hint-face nil :height 0.8)


;;;; doom-modeline integrate
  (defvar doom-modeline--lsp-bridge nil)
  (defun doom-modeline-update-lsp-bridge ()
    "Compose the LSP-bridge's mode-line."
    (if (and doom-modeline-mode (bound-and-true-p lsp-bridge-mode))
        (progn
          (setcar (cdr (assq 'lsp-bridge-mode minor-mode-alist)) "")
          (setcar (cdr (assq 'lsp-bridge-mode mode-line-misc-info)) ""))
      (setcar (cdr (assq 'lsp-bridge-mode minor-mode-alist)) lsp-bridge-mode-lighter))
    (let* ((mode-face
            (if (lsp-bridge-process-live-p)
                'lsp-bridge-alive-mode-line
              'lsp-bridge-kill-mode-line))
           (lighter " 橋")
           (icon (doom-modeline-lsp-icon lighter mode-face))
           )
      (setq doom-modeline--lsp-bridge
            (propertize icon
                        'mouse-face 'doom-modeline-highlight))))

  (doom-modeline-def-segment lsp
    "The LSP server state."
    (when doom-modeline-lsp
      (when-let* ((icon (cond ((bound-and-true-p lsp-mode)
                               doom-modeline--lsp)
                              ((bound-and-true-p eglot--managed-mode)
                               doom-modeline--eglot)
                              ((bound-and-true-p lsp-bridge-mode)
                               doom-modeline--lsp-bridge)
                              ((bound-and-true-p citre-mode)
                               doom-modeline--tags)))
                  (sep (doom-modeline-spc)))
        (concat
         sep
         (doom-modeline-display-icon icon)
         sep))))
  (advice-add #'doom-modeline-update-lsp-icon :after #'lsp-bridge--mode-line-format)
  (add-hook 'lsp-bridge-mode-hook #'doom-modeline-update-lsp-bridge)

  ;; (require 'lsp-bridge)
  ;; (require 'cl)
  (setq acm-enable-tabnine nil)
  (setq acm-enable-doc nil)
  (setq acm-enable-jupyter nil)
  (setq lsp-bridge-toggle-sdcv-helper t)
  (setq acm-enable-codeium nil)
  (setq acm-enable-preview t)
  (setq lsp-bridge-enable-org-babel t)
  (setq lsp-bridge-enable-inlay-hint t) ;; for rust type annotation

  (setq lsp-bridge-org-babel-lang-list '("python" "rust" "sh" "java" "c" "c++" "jupyter-python"))
  (setq lsp-bridge-c-lsp-server "ccls"
        lsp-bridge-python-lsp-server "basedpyright"
        lsp-bridge-python-multi-lsp-server "basedpyright_ruff"
        )
  (setq lsp-bridge-complete-manually nil)
  (defvar my/lsp-bridge-auto-complete-delay 0.5
    "delay time for auto completion")

  ;; (defun lsp-bridge-try-completion ()
  ;;   (cond (lsp-bridge-prohibit-completion
  ;;          (setq-local lsp-bridge-prohibit-completion nil))
  ;;         (t
  ;;          ;; Don't popup completion menu when `lsp-bridge-last-change-position' (cursor before send completion request) is not equal current cursor position.
  ;;          (when (equal lsp-bridge-last-change-position
  ;; 			(list (current-buffer) (buffer-chars-modified-tick) (point)))
  ;;            ;; Try popup completion frame.
  ;; 	     (run-with-idle-timer my/lsp-bridge-auto-complete-delay	1 (lambda () (if (cl-every (lambda (pred)
  ;;                            (lsp-bridge-check-predicate pred "lsp-bridge-try-completion"))
  ;;                          lsp-bridge-completion-popup-predicates)
  ;; 		 (progn
  ;;                  (acm-template-candidate-init)
  ;;                  (acm-update)

  ;;                  ;; We need reset `lsp-bridge-manual-complete-flag' if completion menu popup by `lsp-bridge-popup-complete-menu'.
  ;;                  (when lsp-bridge-complete-manually
  ;;                    (setq-local lsp-bridge-manual-complete-flag nil)))
  ;;              (acm-hide)
  ;;              )))
  ;;            ))))

  (defun lsp-bridge-try-completion ()
    (cond (lsp-bridge-prohibit-completion
           (setq-local lsp-bridge-prohibit-completion nil))
          (t
           ;; Don't popup completion menu when `lsp-bridge-last-change-position' (cursor before send completion request) is not equal current cursor position.
           (when (equal lsp-bridge-last-change-position
		        (list (current-buffer) (buffer-chars-modified-tick) (point)))
             ;; Try popup completion frame.
             (if (cl-every (lambda (pred)
                             (lsp-bridge-check-predicate pred "lsp-bridge-try-completion"))
                           lsp-bridge-completion-popup-predicates)
	         (progn
                   (acm-template-candidate-init)
                   (acm-update)

                   ;; We need reset `lsp-bridge-manual-complete-flag' if completion menu popup by `lsp-bridge-popup-complete-menu'.
                   (when lsp-bridge-complete-manually
                     (setq-local lsp-bridge-manual-complete-flag nil)))
               (acm-hide)
               )))))

  ;; remote
  (setq lsp-bridge-remote-python-command "/home/sawyer/miniconda3/envs/tools/bin/python")
  (setq lsp-bridge-remote-python-file "~/.emacs.d.clean29/straight/repos/lsp-bridge/lsp_bridge.py")
  (setq lsp-bridge-remote-log "~/.emacs.d.clean29/var/lsp-bridge-remote.log")
  (setq lsp-bridge-remote-start-automatically t)
  (setq lsp-bridge-enable-with-tramp t)

  (add-to-list 'lsp-bridge-multi-lang-server-mode-list '((web-mode html-mode) . "html_emmet"))
  (add-to-list 'lsp-bridge-multi-lang-server-mode-list '((css-mode) . "css_emmet"))



  ;; disable corfu-mode
  (add-hook 'lsp-bridge-mode-hook #'(lambda () (when (functionp 'corfu-mode) (corfu-mode -1))))




  (defun lsp-bridge-avy-peek ()
    "Peek any symbol in the file by avy jump."
    (interactive)
    (unless (featurep 'avy)
      (require 'avy))
    (setq lsp-bridge-peek-ace-list (make-list 5 nil))
    (setf (nth 1 lsp-bridge-peek-ace-list) (point))
    (setf (nth 2 lsp-bridge-peek-ace-list) (buffer-name))
    (save-excursion
      (call-interactively 'avy-goto-word-1)
      (lsp-bridge-peek)
      (setf (nth 3 lsp-bridge-peek-ace-list) (buffer-name))
      (setf (nth 4 lsp-bridge-peek-ace-list) (point))))

  (defun my-lsp-bridge-toggle-tabnine ()
    (interactive)
    (if acm-enable-tabnine
        (setq acm-enable-tabnine nil)
      (setq acm-enable-tabnine t)))

  (defun my-lsp-bridge-toggle-acm-english-completion ()
    (interactive)
    (if acm-enable-english-helper
        (setq acm-enable-english-helper nil)
      (setq acm-enable-english-helper t)))

  (defun my-lsp-bridge-toggle-condidate-doc-preview ()
    (interactive)
    (if lsp-bridge-enable-candidate-doc-preview
        (setq lsp-bridge-enable-candidate-doc-preview nil)
      (setq lsp-bridge-enable-candidate-doc-preview t)))

  (defun my-lsp-bridge-toggle-complete-manually ()
    (interactive)
    (if lsp-bridge-complete-manually
        (setq lsp-bridge-complete-manually nil)
      (setq lsp-bridge-complete-manually t)))


  (defun my-lsp-toggle-variable (var)
    ;; (interactive)
    (if var
        (setq var nil)
      (setq var t)))
  (defvar my-lsp-bridge-keymap (make-sparse-keymap) "my keymap for `lsp-bridge'")
  (let ((map my-lsp-bridge-keymap))

    (define-key map (kbd "gd") #'lsp-bridge-find-def)
    (define-key map (kbd "gD") #'lsp-bridge-find-references)
    (define-key map (kbd "gp") #'lsp-bridge-peek)
    (define-key map (kbd "ga") #'lsp-bridge-avy-peek)
    (define-key map (kbd "gi") #'lsp-bridge-find-impl)
    (define-key map (kbd "gI") #'lsp-bridge-find-impl-other-window)
    (define-key map (kbd "gr") #'lsp-bridge-return-from-def)

    (define-key map (kbd "hh") #'lsp-bridge-popup-documentation)
    (define-key map (kbd "hk") #'lsp-bridge-popup-documentation-scroll-down)
    (define-key map (kbd "hj") #'lsp-bridge-popup-documentation-scroll-up)

    (define-key map (kbd "rr") #'lsp-bridge-rename)
    ;; (define-key map (kbd "rf") #'lsp-bridge-rename-file)
    ;; (define-key map (kbd "rh") #'lsp-bridge-rename-highlight)

    ;; (define-key map (kbd "ee") #'lsp-bridge-diagnostic-list)
    ;; (define-key map (kbd "en") #'lsp-bridge-diagnostic-jump-next)
    ;; (define-key map (kbd "ep") #'lsp-bridge-diagnostic-jump-prev)
    ;; (define-key map (kbd "el") #'lsp-bridge-diagnostic-list)
    ;; (define-key map (kbd "ei") #'lsp-bridge-diagnostic-ignore)
    ;; (define-key map (kbd "ec") #'lsp-bridge-diagnostic-copy)

    ;; (define-key map (kbd "ee") #'consult-flymake)
    ;; (define-key map (kbd "en") #'lsp-bridge-diagnostic-jump-next)
    ;; (define-key map (kbd "ep") #'lsp-bridge-diagnostic-jump-prev)
    ;; (define-key map (kbd "el") #'lsp-bridge-diagnostic-list)
    ;; (define-key map (kbd "ei") #'lsp-bridge-diagnostic-ignore)
    ;; (define-key map (kbd "ec") #'lsp-bridge-diagnostic-copy)


    (define-key map (kbd "ee") #'(lambda ()
                                   (interactive)
                                   (cond (flymake-mode
                                          (call-interactively #'consult-flymake))
                                         (t
                                          (call-interactively #'consult-flycheck)))))
    (define-key map (kbd "el") '("list errors" .
                                 (lambda ()
                                   (interactive)
                                   (cond (flymake-mode
                                          (flymake-show-buffer-diagnostics))
                                         (flycheck-mode
                                          (flycheck-list-errors))
                                         (lsp-bridge-mode
                                          (lsp-bridge-list-diagnostics))
                                         (t
                                          nil))
                                   )))
    (define-key map (kbd "en") '("next error" .
                                 (lambda ()
                                   (interactive)
                                   (cond (flymake-mode
                                          (flymake-goto-next-error))
                                         (flycheck-mode
                                          (flycheck-next-error))
                                         (lsp-bridge-mode
                                          (lsp-bridge-jump-to-next-diagnostic))
                                         (t
                                          nil)))))
    (define-key map (kbd "ep") '("prev error" .
                                 (lambda ()
                                   (interactive)
                                   (cond (flymake-mode
                                          (flymake-goto-prev-error))
                                         (flycheck-mode
                                          (flycheck-previous-error))
                                         (lsp-bridge-mode
                                          (lsp-bridge-jump-to-prev-diagnostic))
                                         (t
                                          nil)))))
    (define-key map (kbd "es") #'flymake-cursor-show-errors-at-point-now)



    (define-key map (kbd "wr") #'lsp-bridge-restart-process)
    (define-key map (kbd "wk") #'lsp-bridge-kill-process)

    (define-key map (kbd "Te") #'lsp-bridge-toggle-sdcv-helper)
    (define-key map (kbd "Td") #'my-lsp-bridge-toggle-condidate-doc-preview)
    (define-key map (kbd "Tm") #'my-lsp-bridge-toggle-complete-manually)
    (define-key map (kbd "Tt") #'my-lsp-bridge-toggle-tabnine)
    (define-key map (kbd "==") #'lsp-bridge-code-format)

    (define-key map (kbd "ls") #'lsp-bridge-workspace-list-symbols)

    (define-key map (kbd "ci") #'lsp-bridge-incoming-call-hierarchy)
    (define-key map (kbd "co") #'lsp-bridge-outgoing-call-hierarchy)

    (define-key map (kbd "aa") #'lsp-bridge-code-action)
    (define-key map (kbd "dd") '("dap debug" .
                                 my/dap-hydra))


    map)

  (define-key lsp-bridge-mode-map (kbd "M-\'") my-lsp-bridge-keymap)


  (setq lsp-bridge-python-file
        (if (file-exists-p (expand-file-name "lsp_bridge.py" (file-name-directory (locate-library "lsp-bridge"))))
            (expand-file-name "lsp_bridge.py" (file-name-directory (locate-library "lsp-bridge")))
          (expand-file-name "../../../repos/lsp-bridge/lsp_bridge.py" (locate-library "lsp-bridge"))))

  (setq lsp-bridge-python-command
        (cond (my/windows-p
               ;; "d:/soft/miniconda3/envs/tools/python.exe"
               ;; "e:/soft/envs/win-conda/envs/tools/python.exe"
               my/epc-python-command
               )
              (t
               ;; (expand-file-name "~/miniconda3/envs/tools-pypy/bin/pypy3")
               (expand-file-name "~/miniconda3/envs/tools/bin/python")
               )))


  (require 'yasnippet)
  (yas-global-mode 1)

  ;; minibuffer setup
  (remove-hook 'minibuffer-setup-hook #'lsp-bridge-enable-in-minibuffer)

  ;; doc tooltip
  (if my/4k-p
      (setq lsp-bridge-lookup-doc-tooltip-border-width 20)
    (setq lsp-bridge-lookup-doc-tooltip-border-width 5))

  ;; advice for `conda-env-activate'
  (defun my/lsp-bridge-restart-conda-advice (&rest args)
    (when lsp-bridge-epc-process
      (lsp-bridge-restart-process)))

  (advice-add 'conda-env-activate :after #'my/lsp-bridge-restart-conda-advice)

  (defun my/enable-tabnine-bridge ()
    (interactive)
    (require 'tabnine-bridge)
    (setq acm-enable-tabnine-helper t))
  :commands (tabnine-bridge-install-binary
             tabnine-bridge-kill-process
             tabnine-bridge-restart-server))

(use-package lsp-bridge-ref
  :commands (lsp-bridge-ref-mode
             )
  :bind (:map lsp-bridge-ref-mode-map
              ("M-n" . lsp-bridge-ref-jump-next-keyword)
              ("M-p" . lsp-bridge-ref-jump-prev-keyword)
              ("M-q" . lsp-bridge-ref-quit))
  :bind (:map lsp-bridge-ref-mode-edit-map
              ("C-c C-c" . lsp-bridge-ref-apply-changed)))

;; (use-package flymake-bridge
;;   :after lsp-bridge
;;   :hook (lsp-bridge-mode . flymake-bridge-setup))

(use-package fate-flycheck-bridge
  :after lsp-bridge
  :hook (lsp-bridge-mode . flycheck-lsp-bridge-setup))

(defun my/lsp-bridge-clean-inlay ()
  (with-eval-after-load 'lsp-bridge
    (when lsp-bridge-enable-inlay-hint
      (my/clean-overlay)))
  )

(add-hook 'lsp-bridge-mode-hook #'my/lsp-bridge-clean-inlay)

(provide 'init-lsp-bridge)
