;;; Command Usage
;; emacs -Q -L /home/sawyer/.conf.d -l raw-meow-load.el --init-directory /home/sawyer/.emacs.d.raw -nw $@

;;; Codes
(add-to-list 'load-path (file-name-directory load-file-name))
(require 'init-load-tools)
(require 'init-proxy)
(add-to-list 'load-path my/extra.d-dir)
(require 'init-logging)
;; (require 'init-esup)
(defvar my/install-packages-p t
  "install packages")

;;; benchmark init
;;(require 'init-benchmark-init)

;;; generate autoloads
;;;; .conf.d/extra.d
;; (when my/install-packages-p
;;   (require 'package)
;;   (package-generate-autoloads "extra.d" my/extra.d-dir))


;; not allow root install packages
(when (string-equal "root" user-login-name)
  (setq my/install-packages-p nil))

(use-package savehist
  :init
  (savehist-mode))

;(use-package recentf
;  :config
;  (if (file-exists-p recentf-save-file)
;      (setq recentf-auto-cleanup 'never) ;; disable before we start recentf!
;    )
;  (setq recentf-max-saved-items 1000)
;  (add-to-list 'recentf-exclude  ".gpg\\'")
;  (recentf-mode 1))

(use-package init-recentf)
(defvar bootstrap-version)

(defun my/enable-straight ()
  (interactive)
  (let ((bootstrap-file
	 (expand-file-name
	  "straight/repos/straight.el/bootstrap.el"
	  (or (bound-and-true-p straight-base-dir)
	      user-emacs-directory)))
	(bootstrap-version 7))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
	  (url-retrieve-synchronously
	   "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	   'silent 'inhibit-cookies)
	(goto-char (point-max))
	(eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage)))

(defun my/find-package-path (package)
  "package name is a symbol"
  (expand-file-name (symbol-name package)
		    (expand-file-name "straight/build" prefix)) ;; package build prefix
  )
(let* ((prefix user-emacs-directory)
       (straight-base-dir prefix)
       ;; (packages my/install-packages)
       (packages nil)
       ;; (installed-packages (cl-remove-if-not (lambda (p) (file-exists-p (my/find-package-path p))) packages))
       ;; (enable-straight-p (or my/install-packages-p (< (seq-length installed-packages)
       ;; 						       (seq-length packages))))
       (enable-straight-p my/install-packages-p)
       )
  (when enable-straight-p
    (my/enable-straight))
  
  (dolist (package packages)
    (when my/install-packages-p
      ;;(straight-use-package package)
      )
    (add-to-list 'load-path (my/find-package-path package))
    )
  (add-subdirs-to-load-path (expand-file-name "straight/build/" prefix))
  )

(use-package extra.d-autoloads
  :demand t
  :requires (dired dired-x)
  )

(use-package init-no-littering)
(use-package init-hydra)
(use-package init-xah-fly-keys-core)
(use-package init-vertico)
(use-package init-consult)
(use-package init-embark)
(use-package init-corfu
  :after eglot)
(use-package init-exec-path-from-shell)
(use-package init-search)
(use-package init-regexp)
(use-package init-dired)
(use-package init-tty)
(use-package init-ansi-color)
(use-package init-shell)
(use-package init-format)
(use-package init-thing-edit)
(use-package init-persp-mode)
(use-package init-treesit)
(use-package init-folding)
(use-package init-font)
(use-package init-unicode-fonts)
(use-package init-emacs-lisp)
(use-package init-page-break-lines)
(use-package init-project)
(use-package init-doom-modeline)
(use-package init-ui)
(use-package init-ace-window)
;; (use-package init-highlight-indent-guides)
(use-package init-indent-bars)
(use-package init-yasnippet
  :defer 3)
(use-package init-lsp-bridge)
(use-package init-docsets)
(use-package init-major-modes)
(use-package init-file-templates)
(use-package init-jump)
(use-package init-mwim)
(use-package init-dictionary)
(use-package init-expand-region)
(use-package init-pyim)
;; (use-package init-liberime)
(use-package init-rime)
(use-package init-openai)
(use-package init-w3m)
(use-package init-elfeed)
(use-package init-ai-code)
(use-package init-git)
(use-package init-zoom)
(use-package init-line-number)
(use-package init-ws-butler)
(use-package init-key-chord)
(use-package init-python)
(use-package init-dap-mode)

(when (locate-library "init-host")
  (use-package init-host))
(use-package org
  :init
  (use-package init-org)
  :mode (("\\.org\\'" . org-mode)))

(use-package init-org-roam)
(use-package init-poporg)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(if (display-graphic-p)
    ;; (load-theme 'modus-vivendi t)
    (load-theme 'doom-vibrant t)
  (load-theme 'tsdh-dark t)
  ;; (load-theme 'doom-vibrant t)
  )

(global-auto-revert-mode 1)

(when argv
  (setq inhibit-splash-screen t))


(defun my/kill-emacs-save-or-server-edit ()
  " check if server done before save buffers and kill emacs"
  (interactive)
  (if (daemonp)
      (when-let ((server-already-done (string-equal "No server buffers remain to edit" (server-edit))))
        (save-buffers-kill-terminal))
    (save-buffers-kill-terminal)))

(defvar my/server-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "s") #'server-edit)
    (define-key map (kbd "k") #'save-buffers-kill-emacs)
    (define-key map (kbd "d") #'server-start)
    map))

(defvar my/search-keymap (make-sparse-keymap)
  "keymap for search")

(let ((map my/search-keymap))
  (define-key map (kbd ";") #'blink-search)

  (define-key map (kbd "s") #'+default/search-buffer)
  (define-key map (kbd "f") '("find file path" . consult-find))
  (define-key map (kbd "p") '("find file content" . consult-ripgrep))
  (define-key map (kbd "i") #'(lambda ()
                                (interactive)
                                (cond
                                 ((eq major-mode 'org-mode)
                                  (consult-org-heading))
                                 ((or (derived-mode-p 'outline-mode 'markdown-mode))
                                  (consult-outline))
                                 ((derived-mode-p 'compilation-mode)
                                  (consult-compile-error))
                                 (t
                                  (consult-imenu)))))
  (define-key map (kbd "I") #'consult-imenu-multi)

  ;; * docsets or devdocs
  (define-key map (kbd "o") #'+lookup/online)
  (define-key map (kbd "d") #'devdocs-dwim)
  ;; (define-key map (kbd "d") #'my/counsel-dash-at-point)
  (define-key map (kbd "D") #'consult-dash)
  (define-key map (kbd "z") #'zeal-at-point)

  ;; * dictionary
  ;; (define-key map (kbd "y") #'my-youdao-dictionary-search-at-point)
  (define-key map (kbd "y") #'fanyi-dwim2)
  (define-key map (kbd "b") #'popweb-dict-bing-pointer)
  (define-key map (kbd "v") #'popweb-dict-bing-input)
  (define-key map (kbd "u") #'my/dictionary-overlay-mark-word-unknown)
  (define-key map (kbd "U") #'my/dictionary-overlay-mark-word-known)
  (define-key map (kbd "r") #'my/dictionary-overlay-toggle)


  ;; * char, word jump
  ;; (define-key map (kbd "j") #'ace-pinyin-jump-word)
  (define-key map (kbd "k") #'avy-goto-word-1)
  (define-key map (kbd "j") #'avy-goto-char)
  (define-key map (kbd "h") #'my/avy-goto-word-start-2)
  (define-key map (kbd "l") #'avy-goto-line)
  (define-key map (kbd "2") #'avy-goto-char-2)

  ;; * line jump
  (define-key map (kbd "n") #'(lambda ()
                                (interactive)
                                (cond
                                 ((memq major-mode '(compilation-mode Info-mode eww-mode))
                                  (ace-link))
                                 (t (avy-goto-line)))))
  (define-key map (kbd "q") #'+default/search-buffer)

  ;; embark
  (define-key map (kbd ".") #'embark-act)

  ;; C-g
  (define-key map (kbd "g") #'keyboard-quit)

  ;; web
  (define-key map (kbd "w") #'webjump)

  map)

;; global keys
(global-set-key (kbd "M-o") #'other-window)
(global-set-key (kbd "M-Y") #'duplicate-line)
(global-set-key (kbd "M-i") #'completion-at-point)
(global-unset-key (kbd "C-h r"))
(global-set-key (kbd "C-h r r") (lambda ()
                                  (interactive)
                                  (load-file (expand-file-name "raw-meow-load.el" my/conf-distro-dir))))
(global-set-key (kbd "C-h t") (lambda ()
                                (interactive)
                                (if (functionp 'consult-theme)
                                    (call-interactively #'consult-theme)
                                  (call-interactively #'load-theme))))

(global-set-key (kbd "<f7>") #'my/meow-insert-normal-toggle)
(global-set-key (kbd "M-<up>") #'move-text-up)
(global-set-key (kbd "M-<down>") #'move-text-down)
(global-set-key (kbd "M-K") #'move-text-up)
(global-set-key (kbd "M-J") #'move-text-down)


;;; meow config
(my/straight-if-use 'meow)

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

(use-package meow)

(meow-thing-register 'filename #'my/meow--inner-of-filename #'my/meow--bounds-of-filename)
(meow-thing-register 'url #'my/meow--inner-of-url #'my/meow--thing-url)
(add-to-list 'meow-char-thing-table '(?f . filename))
(add-to-list 'meow-char-thing-table '(?u . url))

(setq meow-use-clipboard t)

(defun my/meow-quit (&optional arg)
  "Quit current window or buffer."
  (interactive "P")
  (cond
   ((derived-mode-p 'lsp-bridge-ref-mode) (lsp-bridge-ref-quit))
   (t (call-interactively #'meow-quit))))

(defun my/meow-insert-normal-toggle ()
  (interactive)
  (cond ((meow-insert-mode-p)
         (call-interactively #'meow-escape-or-normal-modal))
        (t
         (call-interactively #'meow-insert))))

(defun meow-setup ()
  (interactive)
  )

;; * hooks
(defun my/enable-delete-active-region ()
  (interactive)
  (setq delete-active-region t))
(add-hook 'meow-global-mode-hook #'my/enable-delete-active-region)

;; * start meow mode

(setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)

(meow-leader-define-key
 ;; SPC j/k will run the original command in MOTION state.
 '("j" . "H-j")
 '("k" . "H-k")
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
 '("?" . meow-cheatsheet))

;; * meow-motion
(meow-motion-overwrite-define-key
 (cons "q" my/search-keymap)
 '("Q" . "H-q")
 '("j" . meow-next)
 '("k" . meow-prev)
 '("C-M-j" . "H-j")
 '("C-M-k" . "H-k")
 '("~" . other-frame)
 '("<escape>" . ignore)
 '("\\" . my/meow-quit)
 )

(meow-leader-define-key
 (cons "q q"  '("kill emacs" . my/kill-emacs-save-or-server-edit)))

(global-unset-key (kbd "C-c b"))
(global-unset-key (kbd "C-c f"))
(global-unset-key (kbd "C-c j"))
(global-unset-key (kbd "C-c k"))
(global-unset-key (kbd "C-c w"))
;; (global-unset-key (kbd "C-c s"))
(global-unset-key (kbd "C-x C-0"))


(meow-leader-define-key
 '("r" . vr/query-replace)
 '("f" . switch-to-buffer)
 '("H" . beginning-of-buffer)
 '("N" . end-of-buffer)
 '(";" . save-buffer)
 '("w" . xah-shrink-whitespaces)
 '("u" . (lambda () (interactive) (kill-buffer (current-buffer))))


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
 '("l a" . org-agenda)
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
 '("l W" . whitespace-mode)
 ;; '("l " . nil)                      ;; uesed as prefix for elfeed
 '("l x" . xwidget-webkit-browse-url)

 '("i /" . revert-buffer-with-coding-system)
 '("i ;" . write-file)
 '("i v" . my/xah-open-in-vscode)
 ;; '("i a a" . codegeex-request-completion)
 ;; '("i a b" . baidu-translate-zh-mark)
 ;; '("i a c c" . my/chatgpt-interface-prompt-region-action)
 ;; '("i a c d" . codegpt-doc)
 ;; '("i a c e" . codegpt-explain)
 ;; '("i a c f" . codegpt-fix)
 ;; '("i a c i" . codegpt-improve)
 ;; '("i a e" . chatgpt-explain-region)
 ;; '("i a f" . chatgpt-fix-region)
 ;; '("i a l" . chatgpt-login)
 ;; '("i a p" . my/chatgpt-interface-prompt-region)
 ;; '("i a q" . chatgpt-query)
 ;; '("i a r" . chatgpt-refactor-region)
 ;; '("i a t" . chatgpt-gen-tests-for-region)
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
 '("d T" . my/xah-insert-time)
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
 '("b" . major-mode-hydra)
 ;; M-x
 '("a" . execute-extended-command)
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
 ;; '(";" . move-end-of-line)
 ;; '(":" . meow-reverse)

 ;; back-button
 '("=" . back-button-local-backward)
 '("+" . back-button-local-forward)

 ;; thing
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
 ;; '("v" . my/meow-visit)
 '("v" . recenter-top-bottom)
 '("V" . meow-visit)
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
 '("~" . other-frame)
 '("|" . split-window-right)

 ;; region
 '(":" . er/expand-region)

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

(key-chord-define meow-insert-state-keymap "jj" #'meow-insert-exit)
(key-chord-define meow-insert-state-keymap "JJ" #'meow-insert-exit)

;; * meow mode state list
(add-to-list 'meow-mode-state-list '(eaf-mode . motion))
(add-to-list 'meow-mode-state-list '(calc-mode . insert))
(add-to-list 'meow-mode-state-list '(fanyi-mode . normal))
(add-to-list 'meow-mode-state-list '(eww-mode . normal))
(add-to-list 'meow-mode-state-list '(blink-search-mode . insert))
(add-to-list 'meow-mode-state-list '(eat-mode . insert))
(add-to-list 'meow-mode-state-list '(ediff-mode . insert))


(add-hook 'ediff-mode-hook (lambda () (remove-hook 'ediff-mode-hook #'meow-motion-mode) (meow-insert-mode 1)))

(meow-global-mode 1)



;;; eglot lsp

(my/straight-if-use '(flymake :type built-in))
(my/straight-if-use '(xref :type built-in))
(defvar my/lsp-basic-map nil
  "parent keymap for all sub-keymaps")

(setq my/lsp-basic-map
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "ee") '("consult errors" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (consult-flymake))
                                             (flycheck-mode
                                              (consult-lsp-diagnostics))
                                             (lsp-bridge-mode
                                              (lsp-bridge-list-diagnostics))
                                             (t
                                              nil)))) )
        (define-key map (kbd "el") '("list errors" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-show-buffer-diagnostics))
                                             (flycheck-mode
                                              (flycheck-list-errors))
                                             (lsp-bridge-mode
                                              (lsp-bridge-list-diagnostics))
                                             (t
                                              nil))
                                       )))
        (define-key map (kbd "en") '("next error" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-goto-next-error))
                                             (flycheck-mode
                                              (flycheck-next-error))
                                             (lsp-bridge-mode
                                              (lsp-bridge-jump-to-next-diagnostic))
                                             (t
                                              nil)))))
        (define-key map (kbd "ep") '("prev error" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-goto-prev-error))
                                             (flycheck-mode
                                              (flycheck-previous-error))
                                             (lsp-bridge-mode
                                              (lsp-bridge-jump-to-prev-diagnostic))
                                             (t
                                              nil)))))
        (define-key map (kbd "es") '("error at point" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-show-diagnostic (point)))
                                             (flycheck-mode
                                              (flycheck-explain-error-at-point))
                                             (lsp-bridge-mode ;; no support
                                              nil)
                                             (t
                                              nil))
                                       )))
        (define-key map (kbd "dd") '("dap debug" .
                                     my/dap-hydra))
        map))

(with-eval-after-load 'eglot
  (add-hook 'eglot-managed-mode-hook #'corfu-mode))
(use-package eglot
  :init
  :commands (eglot
	     eglot-ensure
	     eglot--managed-mode
	     eglot-shutdown-all)
  :config
  (use-package consult)
  ;; add backend lsp server
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 "basedpyright-langserver" "--stdio"))


  (defun my/eglot-completion-fix ()
    (use-package cape)
    (setq-local completion-at-point-functions
                (list
                 #'cape-file
                 (cape-capf-super
                  #'eglot-completion-at-point
                  ))))
    
  (defun my/eglot-completion-fix ()
    (use-package cape)
    (add-to-list 'completion-at-point-functions #'cape-file)
    (add-to-list 'completion-at-point-functions (cape-capf-super
						 #'eglot-completion-at-point
						 )))

  (add-hook 'eglot-managed-mode-hook #'my/eglot-completion-fix)
  (defun my-eglot-restart ()
    (interactive)
    ;; (eglot-shutdown (eglot-current-server))
    (call-interactively #'eglot))

  (defvar my-eglot-keymap
    nil
    "my keymap for eglot-mode")
  ;; (setq my/eglot-workspace-map
  ;;       (let ((map (make-sparse-keymap)))
  ;;         (define-key )))
  (setq my-eglot-keymap
        (let ((map (make-sparse-keymap)))
          (set-keymap-parent map my/lsp-basic-map)
          (bind-key "wr" #'my-eglot-restart map)
          (bind-key "wk" #'eglot-shutdown map)
          (bind-key "wc" #'eglot-reconnect map)

          (bind-key "rr" #'eglot-rename map)

          (bind-key "==" #'eglot-format map)
          (bind-key "=b" #'eglot-format-buffer map)

          (bind-key "hh" #'eldoc-box-help-at-point map)
          ;; (bind-key "hh" #'eldoc-doc-buffer map)
          (bind-key "hm" #'eglot-manual map)

          (bind-key "aa" #'eglot-code-actions map)
          (bind-key "ai" #'eglot-code-action-inline map)
          (bind-key "ae" #'eglot-code-action-extract map)
          (bind-key "aq" #'eglot-code-action-quickfix map)
          (bind-key "ao" #'eglot-code-action-organize-imports map)
          (bind-key "ar" #'eglot-code-action-rewrite map)

          map))
  (bind-key "M-'" my-eglot-keymap eglot-mode-map)

  (setq completion-category-defaults nil)

  (defun my/capf-use-ai-code ()
    (when (locate-library "codeium")
      (require 'codeium))
    (add-hook 'eglot-managed-mode-hook #'eglot-completion-at-point nil t)
    (dolist (backend '(codeium-completion-at-point))
      (when (fboundp backend)
        (add-hook 'completion-at-point-functions backend nil t))))
  (add-hook 'eglot-managed-mode-hook #'my/capf-use-ai-code)

  )


;;; lsp toggle
(defvar my/lsp-backend "eglot"
  "use `lsp-bridge' or `eglot'")



(setq my/lsp-toggle-mode-hooks
      '(
        python-base-mode-hook
        ;; python-mode-hook
        ;; python-ts-mode-hook
        c++-mode-hook
        c++-ts-mode-hook
        c-mode-hook
        c-ts-mode-hook
        cmake-mode-hook
        cmake-ts-mode-hook
        java-mode-hook
        java-ts-mode-hook
        web-mode-hook
        js-mode-hook
        js-ts-mode-hook
        javascript-mode-hook
        javascript-ts-mode-hook
        typescript-mode-hook
        typescript-ts-mode-hook
        css-mode-hook
        css-ts-mode-hook
        html-mode-hook
        html-ts-mode-hook
        rust-mode-hook
        rust-ts-mode-hook))

(defvar my/lsp-backend-alist '(
                               ("lsp-bridge" . my-enable-lsp-bridge)
                               ("eglot" . my-enable-eglot))
  "backend name <--> backend enable function")

(setq my/lsp-basic-map
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "ee") '("consult errors" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (consult-flymake))
                                             (flycheck-mode
                                              (consult-lsp-diagnostics))
                                             (lsp-bridge-mode
                                              (lsp-bridge-list-diagnostics))
                                             (t
                                              nil)))) )
        (define-key map (kbd "el") '("list errors" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-show-buffer-diagnostics))
                                             (flycheck-mode
                                              (flycheck-list-errors))
                                             (lsp-bridge-mode
                                              (lsp-bridge-list-diagnostics))
                                             (t
                                              nil))
                                       )))
        (define-key map (kbd "en") '("next error" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-goto-next-error))
                                             (flycheck-mode
                                              (flycheck-next-error))
                                             (lsp-bridge-mode
                                              (lsp-bridge-jump-to-next-diagnostic))
                                             (t
                                              nil)))))
        (define-key map (kbd "ep") '("prev error" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-goto-prev-error))
                                             (flycheck-mode
                                              (flycheck-previous-error))
                                             (lsp-bridge-mode
                                              (lsp-bridge-jump-to-prev-diagnostic))
                                             (t
                                              nil)))))
        (define-key map (kbd "es") '("error at point" .
                                     (lambda ()
                                       (interactive)
                                       (cond (flymake-mode
                                              (flymake-show-diagnostic (point)))
                                             (flycheck-mode
                                              (flycheck-explain-error-at-point))
                                             (lsp-bridge-mode ;; no support
                                              nil)
                                             (t
                                              nil))
                                       )))
        (define-key map (kbd "dd") '("dap debug" .
                                     my/dap-hydra))
        map))


(defun my-start-lsp-bridge-fn ()
  (interactive)
  (lsp-bridge-mode))

(defun my-start-eglot-fn ()
  (interactive)
  (eglot-ensure))


(defun my-enable-lsp-bridge ()
  (interactive)
  ;; (setq lsp-completion-enable nil)
  ;; (global-lsp-bridge-mode)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (add-hook hook #'my-start-lsp-bridge-fn)
    (add-hook hook #'breadcrumb-local-mode))
  (my-disable-eglot)
  )

(defun my-enable-eglot ()
  (interactive)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (add-hook hook #'my-start-eglot-fn)
    (add-hook hook #'breadcrumb-local-mode))
  (my-disable-lsp-bridge))

(defun my-disable-lsp-bridge ()
  (interactive)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (remove-hook hook #'my-start-lsp-bridge-fn)))


(defun my-disable-eglot--managed-mode ()
  (interactive)
  (when (and (boundp #'eglot--managed-mode) eglot--managed-mode)
    (eglot--managed-mode -1)))

(defun my-disable-eglot ()
  (interactive)
  (dolist (hook my/lsp-toggle-mode-hooks)
    (remove-hook hook #'my-start-eglot-fn)
    (add-hook hook #'my-disable-eglot--managed-mode))
  (ignore-errors
    (eglot-shutdown-all)))


(my/straight-if-use '(flymake-cursor :type git :host github :repo "flymake/emacs-flymake-cursor"))
(use-package flymake-cursor
  :commands (flymake-cursor-mode
             flymake-cursor-show-errors-at-point-now))


(my/straight-if-use '(eglot-booster :type git :host github :repo "jdtsmith/eglot-booster"))
(my/straight-if-use 'eldoc-box)

(use-package eglot-booster
  ;; :straight (:type git :host github :repo "jdtsmith/eglot-booster")
  :after eglot
  :if (<= emacs-major-version 29)
  :config
  (if   (executable-find "emacs-lsp-booster")
      (eglot-booster-mode)
    (message "Error: not find executable emacs-lsp-booster"))
  )



(defun my-lsp-toggle ()
  (interactive)
  (let* ((lsp-backends my/lsp-backend-alist)
         (backend-name (completing-read
                        "choose lsp backend:" (mapcar #'car lsp-backends)))
         (selected-backend (cdr
                            (assoc backend-name lsp-backends))))
    (setq my/lsp-backend backend-name)
    (funcall selected-backend)
    (message "selected backend: %s" backend-name)))



(defun my/enable-given-lsp-backend (backend-name)
  "enable lsp backend with given name."
  (funcall (cdr
            (assoc backend-name my/lsp-backend-alist))))

;; enable default backend
(my/enable-given-lsp-backend my/lsp-backend)

(global-set-key (kbd "C-c t l")  #'my-lsp-toggle)

;; * fix pyim
(with-eval-after-load 'pyim
  (add-to-list 'pyim-english-input-switch-functions #'meow-normal-mode-p))

;; * hooks
(defun my/enable-delete-active-region ()
  (interactive)
  (setq delete-active-region t))
(add-hook 'meow-global-mode-hook #'my/enable-delete-active-region)


(provide 'raw-meow-load)
