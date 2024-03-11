;;=================== zeal-at-poin ======================

(use-package zeal-at-point
  :straight t
  :commands (zeal-at-point)
  ;; :bind (("C-c o z" . zeal-at-point)
  ;;        ;; ("C-c \"" . zeal-at-point)
  ;;        )
  :config
  ;; (add-hook 'python-mode-hook
  ;;           (lambda () (setq zeal-at-point-docset '("qt5" "python"))))
  ;; (add-hook 'c++-mode-hook
  ;;           ;; ("qt5" "c" "cpp") -- generate search sequence --> qt5,c,cpp:search_text
  ;;           (lambda () (setq zeal-at-point-docset '("qt5" "c" "cpp"))))

  ;; (add-hook 'latex-mode
  ;;           (lambda ()
  ;;             ((setq zeal-at-point-docset '("latex")))))
  )

(provide 'init-zeal)
