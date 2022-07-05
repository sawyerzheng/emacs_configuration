(provide 'init-regexp)

(use-package visual-regexp
  :straight t
  :commands (vr/replace vr/query-replace vr/mc-mark))

(use-package visual-regexp-steroids
  :straight t
  :commands (vr/isearch-forward
             vr/isearch-backward
             vr/select-replace
             vr/select-query-replace
             vr/select-mc-mark))
