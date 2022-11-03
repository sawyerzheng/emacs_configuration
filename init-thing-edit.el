(use-package thing-edit
  :straight (thing-edit :type git :host github :repo "manateelazycat/thing-edit")
  :config
  ;; (bind-key "SPC '" 'one-key-menu-thing-edit xah-fly-command-map)
  :commands (one-key-menu-thing-edit)
  :defer t
  :config
  (require 'init-one-key)
  (one-key-create-menu
   "THING-EDIT"
   '(
     ;; Copy.
     (("w" . "Copy Word") . thing-copy-word)
     (("s" . "Copy Symbol") . thing-copy-symbol)
     (("m" . "Copy Email") . thing-copy-email)
     (("f" . "Copy Filename") . thing-copy-filename)
     (("u" . "Copy URL") . thing-copy-url)
     (("x" . "Copy Sexp") . thing-copy-sexp)
     (("g" . "Copy Page") . thing-copy-page)
     (("t" . "Copy Sentence") . thing-copy-sentence)
     (("o" . "Copy Whitespace") . thing-copy-whitespace)
     (("i" . "Copy List") . thing-copy-list)
     (("c" . "Copy Comment") . thing-copy-comment)
     (("h" . "Copy Function") . thing-copy-defun)
     (("p" . "Copy Parentheses") . thing-copy-parentheses)
     (("l" . "Copy Line") . thing-copy-line)
     (("a" . "Copy To Line Begin") . thing-copy-to-line-beginning)
     (("e" . "Copy To Line End") . thing-copy-to-line-end)
     ;; Cut.
     (("W" . "Cut Word") . thing-cut-word)
     (("S" . "Cut Symbol") . thing-cut-symbol)
     (("M" . "Cut Email") . thing-cut-email)
     (("F" . "Cut Filename") . thing-cut-filename)
     (("U" . "Cut URL") . thing-cut-url)
     (("X" . "Cut Sexp") . thing-cut-sexp)
     (("G" . "Cut Page") . thing-cut-page)
     (("T" . "Cut Sentence") . thing-cut-sentence)
     (("O" . "Cut Whitespace") . thing-cut-whitespace)
     (("I" . "Cut List") . thing-cut-list)
     (("C" . "Cut Comment") . thing-cut-comment)
     (("H" . "Cut Function") . thing-cut-defun)
     (("P" . "Cut Parentheses") . thing-cut-parentheses)
     (("L" . "Cut Line") . thing-cut-line)
     (("A" . "Cut To Line Begin") . thing-cut-to-line-beginning)
     (("E" . "Cut To Line End") . thing-cut-to-line-end)
     ;; toggle sub-word link char
     (("'" . "cycle space, - and _") . xah-cycle-hyphen-lowline-space))
   t))

(use-package open-newline
  :straight (:type git :host github :repo "manateelazycat/open-newline")
  :commands (open-newline-above
             open-newline-below)
  :bind (("C-O" . open-newline-above)
         ("C-o" . open-newline-below))
  )

(use-package move-text
  :straight (:type git :host github :repo "manateelazycat/move-text")
  :commands (move-text-up
             move-text-down))

(use-package duplicate-line
  :straight (:type git :host github :repo "manateelazycat/duplicate-line")
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

(use-package find-orphan
  :straight (:type git :host github :repo "manateelazycat/find-orphan")
  :commands (find-orphan-function-in-buffer
             find-orphan-function-in-directory)
  )

(provide 'init-thing-edit)
