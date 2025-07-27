;; -*- coding: utf-8; -*-
;; about `csv-mode' and `tsv-mode'

;; ref: https://www.emacswiki.org/emacs/CsvMode
(defun csv-highlight (&optional separator)
  (interactive (list (when current-prefix-arg (read-char "Separator: "))))
  (font-lock-mode 1)
  (let* ((separator (or separator ?\,))
         (n (count-matches (string separator) (point-at-bol) (point-at-eol)))
         (colors (loop for i from 0 to 1.0 by (/ 2.0 n)
                       collect (apply #'color-rgb-to-hex
                                      (color-hsl-to-rgb i 0.3 0.5)))))
    (loop for i from 2 to n by 1
          for c in colors
          for r = (format "^\\([^%c\n]+%c\\)\\{%d\\}" separator separator i)
          do (font-lock-add-keywords nil `((,r (1 '(face (:foreground ,c)))))))))

(my/straight-if-use 'csv-mode)
(use-package csv-mode
  :commands (csv-mode tsv-mode csv-align-mode)
  :mode (("\\.csv\\'" . csv-mode)
         ("\\.tsv\\'" . tsv-mode))
  :hook ((csv-mode . csv-highlight)
         (tsv-mode . (lambda () (csv-highlight ?\t)))))

(defun my/preview-tsv (&optional content)
  (interactive)
  (let* ((content (if (null content) (read-string "tsv data: ") content))
         (content (replace-regexp-in-string (regexp-quote "\\t") "\t" content))
         (content (replace-regexp-in-string (regexp-quote "\\n") "\n" content))
         (buff-name "*tsv preview*")
         (buff (get-buffer-create buff-name)))


    (with-current-buffer buff-name
      (delete-region (point-min) (point-max))
      (tsv-mode)
      (csv-align-mode +1)
      (princ content buff)
      (pop-to-buffer buff))))

(defun my/preview-tsv-win-clipboard ()
  (interactive)
  (my/preview-tsv (my/wsl--get-clipboard)))

(provide 'init-csv)
