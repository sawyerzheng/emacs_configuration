;; -*- coding: utf-8; -*-

(use-package smartparens
  :straight t
  :commands (smartparens-mode)
  :hook ((python-mode
          python-ts-mode
          emacs-lisp-mode
          org-mode
          markdown-mode
          java-mode
          java-ts-mode
          c-mode
          c-ts-mode
          c++-mode
          c++-ts-mode
          cmake-mode
          cmake-ts-mode
          rust-mode
          rust-ts-mode
          ) . smartparens-mode)
  :bind
  (:map smartparens-mode-map
        ("C-M-n" . sp-forward-sexp)
        ("C-M-p" . sp-backward-sexp)
        ("C-M-d" . sp-down-sexp)
        ;; ("C-M-u" . sp-up-sexp)
        ("C-M-S-n" . sp-select-next-thing)
        ("C-M-S-p" . sp-select-previous-thing-exchange))
  :config
  ;; global
  (require 'smartparens-config)

  ;; (add-hook 'minibuffer-setup-hook 'turn-on-smartparens-strict-mode)

  (bind-key [remap c-electric-backspace] 'sp-backward-delete-char smartparens-strict-mode-map)

  ;; pair management
  (sp-with-modes '(minibuffer-inactive-mode minibuffer-mode)
    (sp-local-pair "'" nil :actions nil)
    (sp-local-pair "(" nil :wrap "C-("))

  ;; (sp-with-modes 'org-mode
  ;;   (sp-local-pair "=" "=" :wrap "C-="))

  (sp-with-modes 'textile-mode
    (sp-local-pair "*" "*")
    (sp-local-pair "_" "_")
    (sp-local-pair "@" "@"))

  (sp-with-modes 'web-mode
    (sp-local-pair "{{#if" "{{/if")
    (sp-local-pair "{{#unless" "{{/unless"))

;;; tex-mode latex-mode
  (sp-with-modes '(tex-mode plain-tex-mode latex-mode)
    (sp-local-tag "i" "\"<" "\">"))

;;; lisp modes
  ;; (sp-with-modes sp--lisp-modes
  ;;   (sp-local-pair "(" nil
  ;;                  :wrap "C-("
  ;;                  :pre-handlers '(my-add-space-before-sexp-insertion)
  ;;                  :post-handlers '(my-add-space-after-sexp-insertion)))

  (defun my-add-space-after-sexp-insertion (id action _context)
    (when (eq action 'insert)
      (save-excursion
        (forward-char (sp-get-pair id :cl-l))
        (when (or (eq (char-syntax (following-char)) ?w)
                  (looking-at (sp--get-opening-regexp)))
          (insert " ")))))

  (defun my-add-space-before-sexp-insertion (id action _context)
    (when (eq action 'insert)
      (save-excursion
        (backward-char (length id))
        (when (or (eq (char-syntax (preceding-char)) ?w)
                  (and (looking-back (sp--get-closing-regexp))
                       (not (eq (char-syntax (preceding-char)) ?'))))
          (insert " ")))))

  ;; C++
  (sp-with-modes '(malabar-mode c++-mode java-mode)
    (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET"))))
  (sp-local-pair 'c++-mode "/*" "*/" :post-handlers '((" | " "SPC")
                                                      ("* ||\n[i]" "RET")))

  (sp-with-modes '(js2-mode typescript-mode java-mode)
    (sp-local-pair "/**" "*/" :post-handlers '(("| " "SPC")
                                               ("* ||\n[i]" "RET"))))

  (sp-with-modes 'typescript-mode
    (sp-local-pair "<" ">" :actions '(navigate)))
  )


(provide 'init-smartparens)
