(provide 'init-format)

(use-package format-all
  :straight t
  :commands (format-all-mode
             format-all-buffer
             format-all-region
             format-all-ensure-formatter
             )
  :hook ((c++-mode c-mode) . format-all-mode)
  ;; config default formatters
  :hook (((c++-mode c-mode) . (lambda () (setq format-all-formatters '(("C++" clang-format)))))
         (python-mode . (lambda () (setq format-all-formatters '(("Python" black))))))
  )
