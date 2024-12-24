(require 'thingatpt)

;;;###autoload
(defun my/thingatpt-end-of-symbol ()
  (interactive)
  (unless (ignore-errors
            (if (equal (point) (cdr (bounds-of-thing-at-point 'symbol)))
                (forward-word)
              (end-of-thing 'symbol)))
    (forward-word)))

;;;###autoload
(defun my/thingatpt-beginning-of-symbol ()
  (interactive)
  (unless (ignore-errors
            (if (equal (point) (car (bounds-of-thing-at-point 'symbol)))
                (backward-word)
              (beginning-of-thing 'symbol)))
    (backward-word)))

(my/straight-if-use '(thing-edit :type git :host github :repo "manateelazycat/thing-edit"))
(use-package thing-edit
  :commands (thing-edit-hydra/body
             thing-mark-hydra/body)
  :config

  (defun my/mark-thing-at-point (thing)
    (interactive)
    (let* (start end region)
      (if (member thing '(symbol list sexp defun
                                 filename existing-filename url email uuid word
                                 sentence whitespace line number page))
          (setq region (bounds-of-thing-at-point thing))
        (setq region
              (cond
               ((eq thing 'parentheses) (my/thing-get-parentheses-bounds))
               ((eq thing 'line-begin) (cons (save-excursion
                                               (back-to-indentation)
                                               (point)) (point)))
               ((eq thing 'line-end) (cons (line-end-position) (point)))
               (t nil))))
      (if region
          (progn
            (setq start (car region)
                  end (cdr region))
            (set-mark start)
            (goto-char end)

            (message "%s [ %s ]"
                     (propertize "Mark" 'face 'thing-edit-font-lock-action)
                     (buffer-substring start end)))
        (message "no %s under point" thing))))

  (defun my/thing-get-parentheses-bounds (&rest arg)
    (interactive "P")
    (save-excursion
      (if (thing-edit-in-string-p)
          (cons (1+ (car (thing-edit-string-start+end-points)))
                (cdr (thing-edit-string-start+end-points)))
        (cons (progn
                (backward-up-list)
                (forward-char +1)
                (point))
              (progn
                (up-list)
                (forward-char -1)
                (point))))))

  (pretty-hydra-define thing-mark-hydra (:color blue :quit-key "q")
    ("Mark"
     (

      ("w" (lambda () (interactive) (my/mark-thing-at-point 'word)) "mark word")
      ("f" (lambda () (interactive) (my/mark-thing-at-point 'filename)) "mark filename")
      ("h" (lambda () (interactive) (my/mark-thing-at-point 'defun)) "mark defun")
      ("s" (lambda () (interactive) (my/mark-thing-at-point 'symbol)) "mark symbol")
      ("x" (lambda () (interactive) (my/mark-thing-at-point 'sexp)) "mark sexp")
      ("u" (lambda () (interactive) (my/mark-thing-at-point 'url)) "mark url")
      ("l" (lambda () (interactive) (my/mark-thing-at-point 'line)) "mark line")
      ("t" (lambda () (interactive) (my/mark-thing-at-point 'sentence)) "mark sentence")
      ("p" (lambda () (interactive) (my/mark-thing-at-point 'parentheses)) "(inner)mark parentheses")
      ("i" (lambda () (interactive) (my/mark-thing-at-point 'list)) "(outer)mark list")
      ("g" (lambda () (interactive) (my/mark-thing-at-point 'page)) "mark page")
      ("c" (lambda () (interactive) (my/mark-thing-at-point 'comment)) "mark comment")

      ("a" (lambda () (interactive) (my/mark-thing-at-point 'line-begin)) "mark line-ahead")
      ("e" (lambda () (interactive) (my/mark-thing-at-point 'line-end)) "mark line-end" ))))


  :pretty-hydra
  ((:color blue :quit-key "q")
   ("Copy"
    (("w" thing-copy-word "Copy Word")
     ("s" thing-copy-symbol "Copy Symbol")
     ("m" thing-copy-email "Copy Email")
     ("f" thing-copy-filename "Copy Filename")
     ("u" thing-copy-url "Copy URL")
     ("x" thing-copy-sexp "Copy Sexp")
     ("g" thing-copy-page "Copy Page")
     ("t" thing-copy-sentence "Copy Sentence")
     ("o" thing-copy-whitespace "Copy Whitespace")
     ("i" thing-copy-list "Copy List")
     ("c" thing-copy-comment "Copy Comment")
     ("h" thing-copy-defun "Copy Function")
     ("p" thing-copy-parentheses "Copy Parentheses")
     ("l" thing-copy-line "Copy Line")
     ("a" thing-copy-to-line-beginning "Copy To Line Begin")
     ("e" thing-copy-to-line-end "Copy To Line End"))
    "Cut"
    (("W" thing-cut-word "Cut Word")
     ("S" thing-cut-symbol "Cut Symbol")
     ("M" thing-cut-email "Cut Email")
     ("F" thing-cut-filename "Cut Filename")
     ("U" thing-cut-url "Cut URL")
     ("X" thing-cut-sexp "Cut Sexp")
     ("G" thing-cut-page "Cut Page")
     ("T" thing-cut-sentence "Cut Sentence")
     ("O" thing-cut-whitespace "Cut Whitespace")
     ("I" thing-cut-list "Cut List")
     ("C" thing-cut-comment "Cut Comment")
     ("H" thing-cut-defun "Cut Function")
     ("P" thing-cut-parentheses "Cut Parentheses")
     ("L" thing-cut-line "Cut Line")
     ("A" thing-cut-to-line-beginning "Cut To Line Begin")
     ("E" thing-cut-to-line-end "Cut To Line End"))
    "Mark"
    (("'" thing-mark-hydra/body "mark thing"))
    )
   )



  :bind (:map xah-fly-command-map
              ("'" . thing-edit-hydra/body))
  )


(my/straight-if-use '(open-newline :type git :host github :repo "manateelazycat/open-newline"))
(use-package open-newline
  :commands (open-newline-above
             open-newline-below)
  :bind (("C-O" . open-newline-above)
         ("C-o" . open-newline-below))
  )

(my/straight-if-use '(move-text :type git :host github :repo "manateelazycat/move-text"))
(use-package move-text
  :commands (move-text-up
             move-text-down))

(my/straight-if-use '(duplicate-line :type git :host github :repo "manateelazycat/duplicate-line"))
(use-package duplicate-line
  :commands
  (duplicate-line-or-region-above
   duplicate-line-or-region-below
   duplicate-line-above-comment
   duplicate-line-below-comment)
  :init
  (defun my/duplicate-line-or-region-below (&optional reverse)
    (interactive)
    (message "reverse: %s" reverse)
    (if reverse
        (duplicate-line-or-region-above)
      (duplicate-line-or-region-above t)))
  :bind ("M-Y" . my/duplicate-line-or-region-below))

(my/straight-if-use '(find-orphan :type git :host github :repo "manateelazycat/find-orphan"))
(use-package find-orphan
  :commands (find-orphan-function-in-buffer
             find-orphan-function-in-directory)
  )

(my/straight-if-use '(drag-stuff :type git :host github :repo "rejeep/drag-stuff.el"))
(use-package drag-stuff
  :commands (drag-stuff-mode
             global-drag-stuff-mode))


;; ref: https://github.com/manateelazycat/markmacro
(my/straight-if-use '(markmacro :type git :host github :repo "manateelazycat/markmacro"))
(use-package markmacro
  :bind
  (("C-M-m ;" . markmacro-mark-words)
   ("C-M-m '" . markmacro-mark-lines)
   ("C-M-m /" . markmacro-mark-chars)
   ("C-M-m L" . markmacro-mark-imenus)
   ("C-M-m <" . markmacro-apply-all)
   ("C-M-m >" . markmacro-apply-all-except-first)
   ("C-M-m M" . markmacro-rect-set)
   ("C-M-m D" . markmacro-rect-delete)
   ("C-M-m R" . markmacro-rect-replace)
   ("C-M-m I" . markmacro-rect-insert)
   ("C-M-m C" . markmacro-rect-mark-columns)
   ("C-M-m S" . markmacro-rect-mark-symbols)

   ;; 流程：
   ;; 1. 选择有效区域region-1(限定外围区域)
   ;; 2. 设定region-1 有效markmacro-secondary-region-set
   ;; 3. 选择第二个区域 region-2(设定multi-cursor 位置)
   ;; 4. 设定 region-2 是编辑的位置
   ;;
   ("C-M-m h" . markmacro-secondary-region-set) ;设置二级选中区域
   ("C-M-m H" . markmacro-secondary-region-mark-cursors) ;标记二级选中区域内的光标对象
   ))

(my/straight-if-use 'chinese-word-at-point)
(use-package chinese-word-at-point
  :after 'thingatpt
  :config
  (setq chinese-word-split-command
        (concat "echo %s | "
                (cond (my/linux-p "/usr/bin/python")
                      (t "python"))
                " -m jieba -q -d ' '")

        ))



(provide 'init-thing-edit)
