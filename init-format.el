(provide 'init-format)

(use-package format-all
  :straight t
  :commands (format-all-mode
             format-all-buffer
             format-all-region
             format-all-ensure-formatter)
  :init
  (defvar my/format-all-default-formatters
    '(("Python" black)
      ("C++" clang-format)
      ("C" clang-format)
      ("JSON" prettierd)
      ("Emacs Lisp" emacs-lisp))
    "default formatter for buffer local settings")
  (defun my/format-all-set-formatters-fn ()
    ;; (setq format-all-formatters (alist-get major-mode my/format-all-default-formatters))
    (setq-local format-all-formatters my/format-all-default-formatters)

    )
  :hook ((c++-mode c-mode) . format-all-mode)
  :hook ((format-all-mode
          python-mode
          c++-mode
          c-mode
          json-mode
          markdown-mode
          gfm-mode
          java-mode
          ) . my/format-all-set-formatters-fn))
