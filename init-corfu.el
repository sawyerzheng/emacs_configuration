(use-package corfu
  :straight t
  :commands (corfu-mode)
  :hook (after-init . global-corfu-mode)
  :after orderless
  :custom
  (corfu-cycle t)
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-preview-current nil) ;; Disable current candidate preview
  (corfu-auto nil)
  (corfu-on-exact-match nil)
  (corfu-quit-no-match 'separator)
  (corfu-preselect-first t)
  (corfu-auto-delay 1.0)
  :init
  (my-add-extra-folder-to-load-path "corfu" '("extensions"))
  ;; (add-to-list 'load-path (expand-file-name "extensions" (file-name-directory (locate-library "corfu"))))
  :config
  (defun my-corfu/enable ()
    (interactive)
    (company-mode -1)
    (corfu-mode 1))

  (require 'corfu-history)
  (require 'corfu-info)
  (require 'corfu-quick)
  (require 'corfu-indexed)
  (require 'kind-icon)

  (when (> (frame-pixel-width) 3000)
    ;; (custom-set-faces '(corfu-default ((t (:height 0.9)))))
    (setq kind-icon-use-icons nil)
    (setq corfu-min-width 30))

  (use-package cape
    :after corfu
    :straight t
    :demand t
    :commands (cape-file cape-dabbrev cape-keyword)
    :bind (("C-c ` f" . cape-file)
           ("C-c ` l" . cape-line)
           ("C-c ` s" . cape-symbol))
    :init
    (add-to-list 'completion-at-point-functions #'cape-file)
    (add-to-list 'completion-at-point-functions #'cape-symbol)
    (add-to-list 'completion-at-point-functions #'cape-dabbrev)
    ;; (add-to-list 'completion-at-point-functions #'cape-keyword)
    )
  :bind (:map corfu-map
              ("SPC" . corfu-insert-separator)
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)
              ("M-n" . corfu-next)
              ("M-p" . corfu-previous)))

;; * for terminal
(unless (display-graphic-p)
  (with-eval-after-load 'corfu
    (use-package corfu-terminal
      :after corfu
      :straight (corfu-terminal :type git :repo "https://codeberg.org/akib/emacs-corfu-terminal.git")
      :hook (corfu-mode . corfu-terminal-mode)
      :commands (corfu-terminal-mode))

    (use-package popon
      :demand t
      :straight (popon :type git :repo "https://codeberg.org/akib/emacs-popon.git"))))

(use-package corfu-doc
  :straight t
  :after corfu
  :hook (corfu-mode . corfu-doc-mode)
  :bind (:map corfu-map
              ("C-." . corfu-doc-scroll-down)
              ("C-," . corfu-doc-scroll-up)))




(use-package kind-icon
  :straight t
  :after corfu
  :defer t
  :custom
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(setq completion-cycle-threshold 1)

(use-package orderless
  :straight t
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
  ;; (setq tab-always-indent 'complete)
  (setq tab-always-indent t))

(use-package tempel
  :straight t
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")

  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ;; ("M-*" . tempel-insert)
         )

  :init

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
