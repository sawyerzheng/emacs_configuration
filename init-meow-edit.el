;; * my redefined commands

(defun my/meow-visit (arg)
  "visit symbol at point, if want to use `meow-visit', use C-u my/moeow-visi or `SPC j k v'"
  (interactive "P")
  (cond ((equal arg '(4))
         (meow-visit nil))

        ((equal arg nil)
         (let* ((reverse nil)
                (pos (point))
                (symbol-text (thing-at-point 'symbol))
                (text (if symbol-text
                          (format "\\_<%s\\_>" (regexp-quote (substring-no-properties symbol-text)))
                        ""))
                (visit-point (meow--visit-point text reverse)))
           (if (and symbol-text visit-point)
               (let* ((m (match-data))
                      (marker-beg (car m))
                      (marker-end (cadr m))
                      (beg (if (> pos visit-point) (marker-position marker-end) (marker-position marker-beg)))
                      (end (if (> pos visit-point) (marker-position marker-beg) (marker-position marker-end))))
                 (thread-first
                   (meow--make-selection '(select . visit) beg end)
                   (meow--select))
                 (meow--push-search text)
                 (meow--ensure-visible)
                 (meow--highlight-regexp-in-buffer text)
                 (setq meow--dont-remove-overlay t))
             (message "Visit: %s failed" text))))
        (t
         ;;(or (eq arg '-) (eq arg nil))
         (meow-visit arg))))

(defun my/meow-search-back ()
  (interactive)
  (meow-search '-))


(defun my/meow-next (arg)
  "Move to the next line.

Will cancel all other selection, except char selection.

Use with universal argument to move to the last line of buffer.
Use with numeric argument to move multiple lines at once."
  (interactive "P")
  (unless (or (equal (meow--selection-type) '(expand . char))
              (and (eq (meow--selection-type) nil) (region-active-p)))
    (meow--cancel-selection))
  (cond
   ((meow--with-universal-argument-p arg)
    (goto-char (point-max)))
   (t
    (setq this-command #'next-line)
    (meow--execute-kbd-macro meow--kbd-forward-line))))

(defun my/meow-prev (arg)
  "Move to the previous line.

Will cancel all other selection, except char selection.

Use with universal argument to move to the first line of buffer.
Use with numeric argument to move multiple lines at once."
  (interactive "P")
  (unless (or (equal (meow--selection-type) '(expand . char))
              (and (eq (meow--selection-type) nil) (region-active-p)))
    (meow--cancel-selection))
  (cond
   ((meow--with-universal-argument-p arg)
    (goto-char (point-min)))
   (t
    (setq this-command #'previous-line)
    (meow--execute-kbd-macro meow--kbd-backward-line))))

(defun my/meow-left ()
  "Move to left.

Will cancel all other selection, except char selection. "
  (interactive)
  (when (and (region-active-p)
             (not (or (equal (meow--selection-type) '(expand . char))
                      (and (eq (meow--selection-type) nil) (region-active-p)))))
    (meow-cancel-selection))

  (meow--execute-kbd-macro meow--kbd-backward-char))

(defun my/meow-right ()
  "Move to right.

Will cancel all other selection, except char selection. "
  (interactive)
  (let ((ra (region-active-p)))
    (when (and ra
               (not (or (equal (meow--selection-type) '(expand . char))
                        (and (eq (meow--selection-type) nil) (region-active-p)))))
      (meow-cancel-selection))
    (when (or (not meow-use-cursor-position-hack)
              (not ra)
              (equal '(expand . char) (meow--selection-type)))
      (meow--execute-kbd-macro meow--kbd-forward-char))))



;; * use-package
(use-package meow
  :straight t
  :commands (meow-quit meow-setup meow-global-mode meow-thing-register)
  :config
  ;; * add new editing thing
  (defun my/meow--inner-of-filename ()
    (bounds-of-thing-at-point 'filename))

  (defun my/meow--bounds-of-filename ()
    (when-let (bounds (bounds-of-thing-at-point 'filename))
      (let ((beg (car bounds))
            (end (cdr bounds)))
        (cons beg end))))

  (defun my/meow--inner-of-url ()
    (bounds-of-thing-at-point 'url))

  (defun my/meow--bounds-of-url ()
    (when-let (bounds (bounds-of-thing-at-point 'url))
      (let ((beg (car bounds))
            (end (cdr bounds)))
        (cons beg end))))

  (meow-thing-register 'filename #'my/meow--inner-of-filename #'my/meow--bounds-of-filename)
  (meow-thing-register 'url #'my/meow--inner-of-url #'my/meow--thing-url)
  (add-to-list 'meow-char-thing-table '(?f . filename))
  (add-to-list 'meow-char-thing-table '(?u . url))
  :config
  (setq meow-use-clipboard t)
  (require 'init-xah-fly-keys-core)
  (require 'init-key-chord)

  (defun my/meow-quit (&optional arg)
    "Quit current window or buffer."
    (interactive "P")
    (cond
     ((derived-mode-p 'lsp-bridge-ref-mode) (lsp-bridge-ref-quit))
     (t (call-interactively #'meow-quit))))

  (with-eval-after-load 'pyim
    (defun my/meow-not-insert-mode-p ()
      (not (meow-insert-mode-p)))
    (add-to-list 'pyim-english-input-switch-functions #'my/meow-not-insert-mode-p))

  (defun my/meow-insert-normal-toggle ()
    (interactive)
    (cond ((meow-insert-mode-p)
           (call-interactively #'meow-escape-or-normal-modal))
          (t
           (call-interactively #'meow-insert))))

  (defun meow-setup ()
    (interactive)
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore)
     ;; '("n" . meow-search)
     ;; '("v" . my/meow-visit)

     '("8" . other-window)
     '("9" . recenter-top-bottom)

     '("\\" . my/meow-quit)
     ;; window
     ;; '("`" . other-window)
     ;; '("~" . other-frame)
     ;; '("|" . split-window-right)

     ;; region
     '("=" . er/expand-region)

     ;; pair jump
     '("/" . xah-goto-matching-bracket) ;; "/"

     ;; '("T" . set-mark-command)

     ;; scroll
     ;; '("<" . scroll-down-command)
     ;; '(">" . scroll-up-command)

     )
    (meow-leader-define-key
     ;; SPC j/k will run the original command in MOTION state.
     '("j" . "H-j")
     '("k" . "H-k")
     ;; 0 for delete buffer window
     ;; '("0" . delete-window)

     ;; Use SPC (0-9) for digit arguments.
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("/" . meow-keypad-describe-key)
     '("?" . meow-cheatsheet)

     (cons "q q"  '("kill emacs" . my/kill-emacs-save-or-server-edit))
     )

    (meow-normal-define-key
     (cons "q" my/search-keymap)
     ;; '("0" . delete-window)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '(";" . meow-reverse)
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . meow-change)
     '("d" . meow-backward-delete)
     '("D" . meow-delete)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("g" . meow-cancel-selection)
     '("G" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("m" . meow-join)
     '("n" . meow-search)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     ;; '("q" . my/search-keymap)
     '("Q" . meow-goto-line)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("s" . meow-kill)
     ;; insert new empty line below
     '("S" . open-line)
     '("t" . meow-till)
     '("u" . meow-undo)
     ;; '("U" . meow-undo-in-selection)
     '("U" . undo-redo)
     '("v" . my/meow-visit)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("x" . meow-line)
     '("X" . meow-goto-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("z" . meow-pop-selection)
     '("Z" . xah-comment-dwim)
     '("'" . repeat)

     '("\\" . my/meow-quit)
     ;; window
     '("`" . other-window)
     '(">" . other-window) ;; "."
     '("~" . other-frame)
     '("|" . split-window-right)

     ;; region
     '("=" . er/expand-region)

     ;; pair jump
     '("/" . xah-goto-matching-bracket) ;; "/"

     ;; '("M" . xah-backward-left-bracket) ;; "."
     ;; '(">" . xah-forward-right-bracket) ;; "m"

     '("<escape>" . ignore)
     '("T" . set-mark-command)

     ;; scroll
     '("<" . scroll-down-command)
     '(">" . scroll-up-command)

     ;; line end
     '("X" . mwim-end)
     ;; line start
     '("M" . mwim-beginning)
     ;; insert space
     '("P" . xah-insert-space-after)
     )

    (with-eval-after-load 'back-button
      (meow-normal-define-key
       '("0" . back-button-local-backward)
       '(")" . back-button-local-forward)))
    (global-unset-key (kbd "C-c f"))
    (global-unset-key (kbd "C-c j"))
    (global-unset-key (kbd "C-c k"))
    (global-unset-key (kbd "C-c w"))
    (global-unset-key (kbd "C-c s"))
    (global-unset-key (kbd "C-x C-0"))
    (meow-leader-define-key
     '("r" . vr/query-replace)
     '("f" . switch-to-buffer)
     '("H" . beginning-of-buffer)
     '("N" . end-of-buffer)
     '(";" . save-buffer)
     '("w" . xah-shrink-whitespaces)
     '("u" . xah-save-close-current-buffer)


     ;; jupyter -- buffer
     '("," . beginning-of-buffer)
     '("." . end-of-buffer)

     ;; app`l'ications
     '("l ," . eww)
     '("l -" . async-shell-command)
     '("l ." . visual-line-mode)
     '("l /" . abort-recursive-edit)
     '("l 0" . shell-command-on-region)
     '("l 1" . set-input-method)
     '("l 2" . global-hl-line-mode)
     '("l 4" . global-display-line-numbers-mode)
     '("l 6" . calendar)
     '("l 7" . calc)
     '("l 9" . shell-command)
     '("l ;" . count-matches)
     '("l b" . save-some-buffers)
     '("l c" . flyspell-buffer)
     '("l d" . eshell)
     '("l e" . toggle-frame-maximized)
     '("l f" . shell)
     '("l g" . make-frame-command)
     '("l h" . narrow-to-page)
     '("l i" . toggle-case-fold-search)
     '("l j" . widen)
     '("l k" . narrow-to-defun)
     '("l l" . xah-narrow-to-region)
     '("l m" . jump-to-register)
     '("l n" . toggle-debug-on-error)
     '("l o" . count-words)
     '("l r" . read-only-mode)
     '("l s" . variable-pitch-mode)
     '("l t" . toggle-truncate-lines)
     '("l u" . xah-toggle-read-novel-mode)
     '("l v" . menu-bar-open)
     '("l w" . whitespace-mode)

     '("i /" . revert-buffer-with-coding-system)
     '("i ;" . write-file)
     '("i v" . my/xah-open-in-vscode)
     '("i a a" . codegeex-request-completion)
     '("i a b" . baidu-translate-zh-mark)
     '("i a c c" . my/chatgpt-interface-prompt-region-action)
     '("i a c d" . codegpt-doc)
     '("i a c e" . codegpt-explain)
     '("i a c f" . codegpt-fix)
     '("i a c i" . codegpt-improve)
     '("i a e" . chatgpt-explain-region)
     '("i a f" . chatgpt-fix-region)
     '("i a l" . chatgpt-login)
     '("i a p" . my/chatgpt-interface-prompt-region)
     '("i a q" . chatgpt-query)
     '("i a r" . chatgpt-refactor-region)
     '("i a t" . chatgpt-gen-tests-for-region)
     '("i b" . set-buffer-file-coding-system)
     '("i c" . xah-copy-file-path)
     '("i d" . ibuffer)
     '("i e" . find-file)
     '("i f" . xah-open-file-at-cursor)
     '("i i" . dired-jump)
     '("i j" . recentf-open-files)
     '("i k" . bookmark-bmenu-list)
     '("i l" . xah-new-empty-buffer)
     '("i m" . explorer)
     '("i o" . bookmark-jump)
     '("i p" . bookmark-set)
     '("i r" . revert-buffer)
     '("i u" . eaf-open-browser-with-history)
     '("i s" . eaf-search-it)
     '("i w" . xah-open-in-external-app)
     '("d a" . xah-insert-double-angle-bracket)
     '("d b" . my/xah-insert-singe-bracket)
     '("d c" . insert-char)
     '("d d" . xah-insert-unicode)
     '("d e" . sp-rewrap-sexp)
     '("d f" . xah-insert-date)
     '("d g" . xah-insert-curly-single-quote)
     '("d h" . xah-insert-double-curly-quote)
     '("d i" . xah-insert-ascii-single-quote)
     '("d j" . xah-insert-brace)
     '("d k" . xah-insert-paren)
     '("d l" . xah-insert-square-bracket)
     '("d m" . xah-insert-corner-bracket)
     '("d n" . xah-insert-black-lenticular-bracket)
     '("d o" . xah-insert-tortoise-shell-bracket)
     '("d p" . xah-insert-formfeed)
     '("d r" . xah-insert-single-angle-quote)
     '("d t" . xah-insert-double-angle-quote)
     '("d u" . xah-insert-ascii-double-quote)
     '("d v" . xah-insert-markdown-quote)
     '("d y" . xah-insert-emacs-quote)
     '("e '" . markmacro-mark-lines)
     '("e /" . markmacro-mark-chars)
     '("e ;" . markmacro-mark-words)
     '("e <" . markmacro-apply-all)
     '("e >" . markmacro-apply-all-except-first)
     '("e C" . markmacro-rect-mark-columns)
     '("e D" . markmacro-rect-delete)
     '("e H" . markmacro-secondary-region-mark-cursors)
     '("e I" . markmacro-rect-insert)
     '("e L" . markmacro-mark-imenus)
     '("e M" . markmacro-rect-set)
     '("e R" . markmacro-rect-replace)
     '("e S" . markmacro-rect-mark-symbols)
     '("e a" . ialign)
     '("e d" . isearch-forward-symbol-at-point)
     '("e e" . highlight-symbol-at-point)
     '("e f" . isearch-forward-symbol)
     '("e h" . markmacro-secondary-region-set)
     '("e i" . highlight-lines-matching-regexp)
     '("e j" . highlight-regexp)
     '("e k" . highlight-phrase)
     '("e m" . vr/mc-mark)
     '("e n" . bm-next)
     '("e o" . resize-window)
     '("e p" . bm-previous)
     '("e q" . my/format-buffer-fn)
     '("e r" . isearch-forward-word)
     '("e t" . bm-toggle)
     '("e u" . unhighlight-regexp)
     '("e w" . xah-fill-or-unfill)


     '("j ." . apropos-value)
     '("j /" . describe-coding-system)
     '("j ;" . describe-syntax)

     '("j a" . apropos-command)
     '("j b" . describe-command)
     '("j c" . man)
     '("j d" . view-echo-area-messages)
     '("j e" . embark-act)
     '("j f" . elisp-index-search)
     '("j g" . info)
     '("j h" . apropos-documentation)
     '("j i" . describe-char)
     '("j j" . describe-function)
     '("j k" . universal-argument)
     '("j l" . describe-variable)
     '("j m" . describe-mode)
     '("j n" . describe-bindings)
     '("j o" . apropos-variable)
     '("j p" . view-lossage)
     '("j s" . describe-language-environment)
     '("j u" . info-lookup-symbol)
     '("j v" . describe-key)
     '("j y" . describe-face)
     '("k ," . xah-next-window-or-frame)
     '("k 1" . xah-append-to-register-1)
     '("k 2" . xah-clear-register-1)
     '("k 3" . xah-copy-to-register-1)
     '("k 4" . xah-paste-from-register-1)
     '("k 7" . xah-append-to-register-1)
     '("k 8" . xah-clear-register-1)
     '("k <down>" . xah-move-block-down)
     '("k <up>" . xah-move-block-up)
     '("k b" . xah-reformat-to-sentence-lines)
     '("k c" . copy-to-register)
     '("k d" . list-matching-lines)
     '("k e" . xah-sort-lines)
     '("k f" . delete-matching-lines)
     '("k g" . delete-non-matching-lines)
     '("k h" . mark-defun)
     '("k i" . goto-char)
     '("k j" . repeat-complex-command)
     '("k k" . repeat)
     '("k m" . xah-make-backup-and-save)
     '("k o" . copy-rectangle-as-kill)
     '("k p" . xah-escape-quotes)
     '("k q" . reverse-region)
     '("k r" . query-replace-regexp)
     '("k s" . xah-clean-whitespace)
     '("k t" . delete-duplicate-lines)
     '("k u" . move-to-column)
     '("k v" . insert-register)
     '("k w" . sort-numeric-fields)
     '("k y" . goto-line)


     '("o SPC" .	rectangle-mark-mode)
     '("o 3" .		number-to-register)
     '("o 4" .		increment-register)
     '("o b" .		xah-double-backslash-to-slash)
     '("o c" .		xah-slash-to-backslash)
     '("o d" .		call-last-kbd-macro)
     '("o e" .		kmacro-start-macro)
     '("o f" .		xah-quote-lines)
     '("o g" .		xah-space-to-newline)
     '("o h" .		delete-rectangle)
     '("o i" .		replace-rectangle)
     '("o j" .		xah-change-bracket-pairs)
     '("o l" .		rectangle-number-lines)
     '("o o" .		yank-rectangle)
     '("o p" .		clear-rectangle)
     '("o r" .		kmacro-end-macro)
     '("o s" .		open-rectangle)
     '("o t" .		delete-whitespace-rectangle)
     '("o u" .		kill-rectangle)
     '("o v" .		xah-slash-to-double-backslash)
     '("o w" .		apply-macro-to-region-lines)

     ;; major mode hydra
     '("SPC" . major-mode-hydra)
     ;; M-x
     '("a" . execute-extended-command)
     )

    (meow-normal-define-key
     ;; window manage
     '("8" . other-window)
     '("9" . recenter-top-bottom)
     )

    (key-chord-define meow-insert-state-keymap "jk" #'meow-insert-exit)
    (key-chord-define meow-insert-state-keymap "JK" #'meow-insert-exit)
    (global-set-key (kbd "<f7>") #'my/meow-insert-normal-toggle)
    )
  )

;; * override meow cursor move keys
(advice-add 'meow-left :override #'my/meow-left)
(advice-add 'meow-right :override #'my/meow-right)
(advice-add 'meow-prev :override #'my/meow-prev)
(advice-add 'meow-next :override #'my/meow-next)

;; * hooks
(defun my/enable-delete-active-region ()
  (interactive)
  (setq delete-active-region t))
(add-hook 'meow-global-mode-hook #'my/enable-delete-active-region)

;; * start meow mode
(meow-setup)
(meow-global-mode)

;; * meow mode state list
(add-to-list 'meow-mode-state-list '(eaf-mode . motion))
(add-to-list 'meow-mode-state-list '(calc-mode . insert))

(provide 'init-meow-edit)
