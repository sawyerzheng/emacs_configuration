(defun my/regexp-full-match (regexp string)
  (let* ((len (string-width string))
         (start-match (string-match regexp string)))
    (if (and (not (null start-match))
             (equal start-match 0)
             (equal (match-end 0) len))
        t
      nil)))

(provide 'init-lib-regexp)
