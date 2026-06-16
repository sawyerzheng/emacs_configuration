;; -*- coding: utf-8; -*-
;; about `csv-mode' and `tsv-mode'

;; ref: https://www.emacswiki.org/emacs/CsvMode
(defun csv-highlight (&optional separator)
  (interactive (list (when current-prefix-arg (read-char "Separator: "))))
  (font-lock-mode 1)
  (let* ((separator (or separator ?\,))
         (n (count-matches (string separator) (point-at-bol) (point-at-eol)))
         (colors (cl-loop for i from 0 to 1.0 by (/ 2.0 n)
                          collect (apply #'color-rgb-to-hex
                                         (color-hsl-to-rgb i 0.3 0.5)))))
    (cl-loop for i from 2 to n by 1
             for c in colors
             for r = (format "^\\([^%c\n]+%c\\)\\{%d\\}" separator separator i)
             do (font-lock-add-keywords nil `((,r (1 '(face (:foreground ,c)))))))))

;;;###autoload
(defun csv-highlight (&optional separator)
  "为当前行所在表格的每一列分配一个固定前景色，逐列染色。
不要求字段内容非空，因此能正确处理含有空单元格的行。"
  (interactive (list (when current-prefix-arg (read-char "Separator: "))))
  (font-lock-mode 1)
  (let* ((separator (or separator ?\,))
         (sep-re (regexp-quote (string separator)))
         (n (count-matches sep-re (line-beginning-position) (line-end-position)))
         (ncols (1+ n))
         (available-colors (my/csv-highlight--colors))
         (colors (cl-loop for i from 0 below ncols
                          collect (nth (mod i (length available-colors)) available-colors))))
    ;; 第 1 ~ 第 n 列：每列后面必然跟着一个真实的分隔符字符，
    ;; 所以这条规则永远不会匹配出零长度结果。
    (cl-loop for i from 1 to n
             for c in colors
             for r = (format "^\\(?:[^%c\n]*%c\\)\\{%d\\}\\([^%c\n]*%c\\)"
                             separator separator (1- i) separator separator)
             do (font-lock-add-keywords nil `((,r (1 '(face (:foreground ,c)))))))
    ;; 最后一列：行尾没有分隔符，改用行尾锚点 $。
    ;; 用 (> n 0) 守卫，保证前缀至少吞掉 n>=1 个真实逗号，
    ;; 避免在空行/文件末尾产生零长度匹配而让 font-lock 崩溃。
    (when (> n 0)
      (font-lock-add-keywords
       nil
       `((,(format "^\\(?:[^%c\n]*%c\\)\\{%d\\}\\([^%c\n]*\\)$"
                   separator separator n separator)
          (1 '(face (:foreground ,(nth n colors))))))))))


(defun  my/csv-highlight--colors ()
  "List of colors to use."
  (cond
   ((eq 'light (frame-parameter nil 'background-mode))
    '("#333333"
      "#A96329"
      "#233286"
      "#AD66AA"
      "#317CB5"
      "#732301"
      "#4A3F87"
      "#B1364F"
      "#A96329"
      "#0BB8B8"))
   (t
    '("#CCCCCC"
      "#569CD6"
      "#DCCD79"
      "#529955"
      "#CE834A"
      "#8CDCFE"
      "#B5C078"
      "#4EC9B0"
      "#569CD6"
      "#F44747"))))


(use-package csv-mode
  :commands (csv-mode tsv-mode csv-align-mode)
  :mode (("\\.csv\\'" . csv-mode)
         ("\\.tsv\\'" . tsv-mode))
  :hook ((csv-mode . csv-highlight)
         (tsv-mode . (lambda () (csv-highlight ?\t))))
  ;; :hook ((csv-mode . rainbow-csv-mode)
  ;;        (tsv-mode . rainbow-csv-mode))
  )

(use-package rainbow-csv
  :commands (rainbow-csv-mode))

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
