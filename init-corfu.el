(my/straight-if-use 'popon)
(use-package popon
  :defer t
  )

(my/straight-if-use 'corfu)
(my/straight-if-use '(nerd-icons-corfu :source (melpa)))
(use-package corfu
  :commands (corfu-mode)
  ;; :hook (my/startup . global-corfu-mode)
  :after orderless
  :hook ((eglot-managed-mode) . corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.5)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-separator ?=)          ;; Orderless field separator
  (corfu-preview-current nil) ;; Disable current candidate preview
  (corfu-on-exact-match nil)
  (corfu-quit-no-match 'separator)
  (corfu-preselect-first t)
  :init
  (my/add-extra-folder-to-load-path "corfu" '("extensions"))
  ;; (add-to-list 'load-path (expand-file-name "extensions" (file-name-directory (locate-library "corfu"))))
  :config
  (setq corfu-excluded-modes '(ejc-sql-mode))
  (setq corfu-preselect 'first)
  (defun my-corfu/enable ()
    (interactive)
    (when (functionp 'company-mode)
      (company-mode -1))
    (corfu-mode 1))

  (defun corfu-enable-in-minibuffer ()
    "Enable Corfu in the minibuffer if `completion-at-point' is bound."
    (when (where-is-internal #'completion-at-point (list (current-local-map)))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (my/cape-fix-capf-list)
      (corfu-mode 1)))
  ;; (add-hook 'minibuffer-setup-hook #'corfu-enable-in-minibuffer)

  ;; disable corfu in minibuffer
  (add-to-list 'corfu-excluded-modes 'minibuffer-mode)

  ;; (require 'corfu-indexed)
  (use-package nerd-icons-corfu
    :hook (corfu-mode . (lambda ()
                          (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))))

  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)

  (use-package corfu-history
    :hook (corfu-mode . corfu-history-mode)
    :config
    (savehist-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history))

  (use-package corfu-quick
    :bind (:map corfu-map
                ("M-f" . corfu-quick-complete)
                ("C-q" . corfu-quick-insert)))

  (use-package corfu-info
    :commands (corfu-info-location
               corfu-info-documentation))

  (use-package corfu-popupinfo
    :hook (corfu-mode . corfu-popupinfo-mode)
    :config
    (setq corfu-popupinfo-delay 0.5))

  (when (> (frame-pixel-width) 3000)
    ;; (custom-set-faces '(corfu-default ((t (:height 0.9)))))
    (setq kind-icon-use-icons nil)
    (setq corfu-min-width 30))

  :bind (:map corfu-map
              ("SPC" . corfu-insert-separator)
              ("TAB" . completion-at-point)
              ([tab] . completion-at-point)
              ;; ("TAB" . corfu-next)
              ;; ([tab] . corfu-next)
              ;; ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)
              ("M-n" . corfu-next)
              ("M-p" . corfu-previous))
  :bind (("C-M-i" . completion-at-point)
         ("M-i" . completion-at-point))
  :hook (eshell-mode . (lambda ()
                         (setq-local corfu-auto nil)
                         (corfu-mode))))

(my/straight-if-use 'cape)
(use-package cape
  :after corfu
  :demand t
  :commands (cape-file cape-dabbrev cape-keyword)
  :bind (("C-c ` f" . cape-file)
         ("C-c ` l" . cape-line)
         ("C-c ` s" . cape-symbol))
  :config
  (require 'cape-keyword)
  (defun my/cape-add-to-corfu ()
    (interactive)
    ;; (make-local-variable 'completion-at-point-functions)
    (setq completion-at-point-functions (remove 't completion-at-point-functions))
    (add-to-list 'completion-at-point-functions #'cape-dabbrev t)
    (add-to-list 'completion-at-point-functions #'cape-file t)
    (add-to-list 'completion-at-point-functions #'cape-keyword t)
    (add-to-list 'completion-at-point-functions #'cape-elisp-block t)
    (when (or (derived-mode-p 'org-mode) (derived-mode-p 'TeX-mode))
      (add-to-list 'completion-at-point-functions #'cape-tex))
    (add-to-list 'completion-at-point-functions 't t)
    (my/cape-fix-capf-list))

  (defun my/cape-fix-capf-list ()
    (when (or (derived-mode-p 'shell-mode) (derived-mode-p 'eshell-mode) (derived-mode-p 'minibuffer-mode))
      (setq completion-at-point-functions (remove #'cape-file completion-at-point-functions))
      (add-to-list 'completion-at-point-functions #'cape-file)))

  (add-hook 'minibuffer-setup-hook #'my/cape-fix-capf-list)

  (add-hook 'corfu-mode-hook #'my/cape-add-to-corfu))

;; * for terminal
(my/straight-if-use '(corfu-terminal :type git :repo "https://codeberg.org/akib/emacs-corfu-terminal.git"))
(when (or (not (display-graphic-p))
          (daemonp)
          ;; my/4k-p
          )
  (with-eval-after-load 'corfu
    (require 'popon)
    (use-package corfu-terminal
      :after corfu
      :hook (corfu-mode . my/daemonp-corfu-load-helper)
      :commands (corfu-terminal-mode)
      :config
      (defun my/daemonp-corfu-load-helper ()
        (unless (display-graphic-p)
          (corfu-terminal-mode)))))
  )


(setq completion-cycle-threshold 1)

(my/straight-if-use 'orderless)
(use-package orderless
  :defer t
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete)
  ;; (setq tab-always-indent t)
  )

(my/straight-if-use 'tempel)
(use-package tempel
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")

  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ;; ("M-*" . tempel-insert)
         )

  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))

  :config
  (add-hook 'prog-mode-hook #'tempel-setup-capf)
  (add-hook 'text-mode-hook #'tempel-setup-capf)

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  ;; (global-tempel-abbrev-mode)
  )




(provide 'init-corfu)
