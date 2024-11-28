(use-package popon
      :defer t
      :straight (popon :type git :repo "https://codeberg.org/akib/emacs-popon.git"))

(use-package corfu
  :straight t
  :commands (corfu-mode)
  ;; :hook (my/startup . global-corfu-mode)
  :after orderless
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
    :straight (:source (melpa))
    :hook (corfu-mode . (lambda ()
                          (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))))

  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
  ;; (require 'kind-icon)
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

(use-package cape
  :after corfu
  :straight t
  :demand t
  :commands (cape-file cape-dabbrev cape-keyword)
  :bind (("C-c ` f" . cape-file)
         ("C-c ` l" . cape-line)
         ("C-c ` s" . cape-symbol))
  :config
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
(when (or (not (display-graphic-p))
          (daemonp)
          ;; my/4k-p
          )
  (with-eval-after-load 'corfu
    (require 'popon)

    (use-package corfu-terminal
      :after corfu
      :straight (corfu-terminal :type git :repo "https://codeberg.org/akib/emacs-corfu-terminal.git")
      :hook (corfu-mode . my/daemonp-corfu-load-helper)
      :commands (corfu-terminal-mode)
      :config
      (defun my/daemonp-corfu-load-helper ()
        (unless (display-graphic-p)
          (corfu-terminal-mode)))))
  )

;; (use-package corfu-doc
;;   :straight t
;;   :after corfu
;;   :hook (corfu-mode . corfu-doc-mode)
;;   :bind (:map corfu-map
;;               ("C-." . corfu-doc-scroll-down)
;;               ("C-," . corfu-doc-scroll-up)))



;; (use-package kind-icon
;;   :straight t
;;   :defer t
;;   :custom
;;   (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
;;   :config
;;   (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)

;;   ;; vscode icons
;;   (use-package vscode-icon
;;     :straight t)

;;   ;; (setq kind-icon-mapping
;;   ;;       '((array          "a"   :icon "symbol-array"       :face font-lock-type-face              :collection "vscode")
;;   ;;         (boolean        "b"   :icon "symbol-boolean"     :face font-lock-builtin-face           :collection "vscode")
;;   ;;         (color          "#"   :icon "symbol-color"       :face success                          :collection "vscode")
;;   ;;         (command        "cm"  :icon "chevron-right"      :face default                          :collection "vscode")
;;   ;;         (constant       "co"  :icon "symbol-constant"    :face font-lock-constant-face          :collection "vscode")
;;   ;;         (class          "c"   :icon "symbol-class"       :face font-lock-type-face              :collection "vscode")
;;   ;;         (constructor    "cn"  :icon "symbol-method"      :face font-lock-function-name-face     :collection "vscode")
;;   ;;         (enum           "e"   :icon "symbol-enum"        :face font-lock-builtin-face           :collection "vscode")
;;   ;;         (enummember     "em"  :icon "symbol-enum-member" :face font-lock-builtin-face           :collection "vscode")
;;   ;;         (enum-member    "em"  :icon "symbol-enum-member" :face font-lock-builtin-face           :collection "vscode")
;;   ;;         (event          "ev"  :icon "symbol-event"       :face font-lock-warning-face           :collection "vscode")
;;   ;;         (field          "fd"  :icon "symbol-field"       :face font-lock-variable-name-face     :collection "vscode")
;;   ;;         (file           "f"   :icon "symbol-file"        :face font-lock-string-face            :collection "vscode")
;;   ;;         (folder         "d"   :icon "folder"             :face font-lock-doc-face               :collection "vscode")
;;   ;;         (function       "f"   :icon "symbol-method"      :face font-lock-function-name-face     :collection "vscode")
;;   ;;         (interface      "if"  :icon "symbol-interface"   :face font-lock-type-face              :collection "vscode")
;;   ;;         (keyword        "kw"  :icon "symbol-keyword"     :face font-lock-keyword-face           :collection "vscode")
;;   ;;         (macro          "mc"  :icon "lambda"             :face font-lock-keyword-face)
;;   ;;         (magic          "ma"  :icon "lightbulb-autofix"  :face font-lock-builtin-face           :collection "vscode")
;;   ;;         (method         "m"   :icon "symbol-method"      :face font-lock-function-name-face     :collection "vscode")
;;   ;;         (module         "{"   :icon "file-code-outline"  :face font-lock-preprocessor-face)
;;   ;;         (numeric        "nu"  :icon "symbol-numeric"     :face font-lock-builtin-face           :collection "vscode")
;;   ;;         (operator       "op"  :icon "symbol-operator"    :face font-lock-comment-delimiter-face :collection "vscode")
;;   ;;         (param          "pa"  :icon "gear"               :face default                          :collection "vscode")
;;   ;;         (property       "pr"  :icon "symbol-property"    :face font-lock-variable-name-face     :collection "vscode")
;;   ;;         (reference      "rf"  :icon "library"            :face font-lock-variable-name-face     :collection "vscode")
;;   ;;         (snippet        "S"   :icon "symbol-snippet"     :face font-lock-string-face            :collection "vscode")
;;   ;;         (string         "s"   :icon "symbol-string"      :face font-lock-string-face            :collection "vscode")
;;   ;;         (struct         "%"   :icon "symbol-structure"   :face font-lock-variable-name-face     :collection "vscode")
;;   ;;         (text           "tx"  :icon "symbol-key"         :face font-lock-doc-face               :collection "vscode")
;;   ;;         (typeparameter  "tp"  :icon "symbol-parameter"   :face font-lock-type-face              :collection "vscode")
;;   ;;         (type-parameter "tp"  :icon "symbol-parameter"   :face font-lock-type-face              :collection "vscode")
;;   ;;         (unit           "u"   :icon "symbol-ruler"       :face font-lock-constant-face          :collection "vscode")
;;   ;;         (value          "v"   :icon "symbol-enum"        :face font-lock-builtin-face           :collection "vscode")
;;   ;;         (variable       "va"  :icon "symbol-variable"    :face font-lock-variable-name-face     :collection "vscode")
;;   ;;         (t              "."   :icon "question"           :face font-lock-warning-face           :collection "vscode")))

;;   ;; ;; nerd-icons
;;   (when my/4k-p
;;     (setq kind-icon-use-icons nil)
;;     (setq kind-icon-mapping
;;           `(
;;             (array ,(nerd-icons-codicon "nf-cod-symbol_array") :face font-lock-type-face)
;;             (boolean ,(nerd-icons-codicon "nf-cod-symbol_boolean") :face font-lock-builtin-face)
;;             (class ,(nerd-icons-codicon "nf-cod-symbol_class") :face font-lock-type-face)
;;             (color ,(nerd-icons-codicon "nf-cod-symbol_color") :face success)
;;             (command ,(nerd-icons-codicon "nf-cod-terminal") :face default)
;;             (constant ,(nerd-icons-codicon "nf-cod-symbol_constant") :face font-lock-constant-face)
;;             (constructor ,(nerd-icons-codicon "nf-cod-triangle_right") :face font-lock-function-name-face)
;;             (enummember ,(nerd-icons-codicon "nf-cod-symbol_enum_member") :face font-lock-builtin-face)
;;             (enum-member ,(nerd-icons-codicon "nf-cod-symbol_enum_member") :face font-lock-builtin-face)
;;             (enum ,(nerd-icons-codicon "nf-cod-symbol_enum") :face font-lock-builtin-face)
;;             (event ,(nerd-icons-codicon "nf-cod-symbol_event") :face font-lock-warning-face)
;;             (field ,(nerd-icons-codicon "nf-cod-symbol_field") :face font-lock-variable-name-face)
;;             (file ,(nerd-icons-codicon "nf-cod-symbol_file") :face font-lock-string-face)
;;             (folder ,(nerd-icons-codicon "nf-cod-folder") :face font-lock-doc-face)
;;             (interface ,(nerd-icons-codicon "nf-cod-symbol_interface") :face font-lock-type-face)
;;             (keyword ,(nerd-icons-codicon "nf-cod-symbol_keyword") :face font-lock-keyword-face)
;;             (macro ,(nerd-icons-codicon "nf-cod-symbol_misc") :face font-lock-keyword-face)
;;             (magic ,(nerd-icons-codicon "nf-cod-wand") :face font-lock-builtin-face)
;;             (method ,(nerd-icons-codicon "nf-cod-symbol_method") :face font-lock-function-name-face)
;;             (function ,(nerd-icons-codicon "nf-cod-symbol_method") :face font-lock-function-name-face)
;;             (module ,(nerd-icons-codicon "nf-cod-file_submodule") :face font-lock-preprocessor-face)
;;             (numeric ,(nerd-icons-codicon "nf-cod-symbol_numeric") :face font-lock-builtin-face)
;;             (operator ,(nerd-icons-codicon "nf-cod-symbol_operator") :face font-lock-comment-delimiter-face)
;;             (param ,(nerd-icons-codicon "nf-cod-symbol_parameter") :face default)
;;             (property ,(nerd-icons-codicon "nf-cod-symbol_property") :face font-lock-variable-name-face)
;;             (reference ,(nerd-icons-codicon "nf-cod-references") :face font-lock-variable-name-face)
;;             (snippet ,(nerd-icons-codicon "nf-cod-symbol_snippet") :face font-lock-string-face)
;;             (string ,(nerd-icons-codicon "nf-cod-symbol_string") :face font-lock-string-face)
;;             (struct ,(nerd-icons-codicon "nf-cod-symbol_structure") :face font-lock-variable-name-face)
;;             (text ,(nerd-icons-codicon "nf-cod-text_size") :face font-lock-doc-face)
;;             (typeparameter ,(nerd-icons-codicon "nf-cod-list_unordered") :face font-lock-type-face)
;;             (type-parameter ,(nerd-icons-codicon "nf-cod-list_unordered") :face font-lock-type-face)
;;             (unit ,(nerd-icons-codicon "nf-cod-symbol_ruler") :face font-lock-constant-face)
;;             (value ,(nerd-icons-codicon "nf-cod-symbol_field") :face font-lock-builtin-face)
;;             (variable ,(nerd-icons-codicon "nf-cod-symbol_variable") :face font-lock-variable-name-face)
;;             (t ,(nerd-icons-codicon "nf-cod-code") :face font-lock-warning-face))))


;;   ;; (add-hook 'my-completion-ui-mode-hook
;;   ;;  	    (lambda ()
;;   ;;  	      (setq completion-in-region-function
;;   ;;  		    (kind-icon-enhance-completion
;;   ;;  		     completion-in-region-function))))
;;   )

;; (with-eval-after-load 'corfu
;;   (require 'kind-icon))
;; (with-eval-after-load 'minibuffer
;;   (require 'kind-icon))

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
  (setq tab-always-indent 'complete)
  ;; (setq tab-always-indent t)
  )

(use-package tempel
  :straight t
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
