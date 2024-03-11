;; -*- coding: utf-8; -*-
;; (setq user-emacs-directory (expand-file-name "~/.emacs.d.quick"))

(defvar my/enable-doom-modeline-p nil
  "if use `doom-modeline'")

;; theme
(defvar my/theme-to-load
  ;; 'doom-one
  'tsdh-dark
  "tsdh-dark, doom-one")
(with-eval-after-load 'init-font
  (setq my/theme-to-load 'doom-one))

(defvar my/enable-file-history-p nil
  "recentf-mode")

(defvar my/use-eaf-p t)

(defvar my/load-extra-p t
  "if load extra packages")


(when my/load-extra-p

  (defvar my/conf-distro-dir (file-name-directory load-file-name)
    "folder to place most init files")

  (defvar my/extra.d-dir (expand-file-name "extra.d" my/conf-distro-dir)
    "folder to my manualy downloaded elisp packages")

  (add-to-list 'load-path my/conf-distro-dir)
  (add-to-list 'load-path my/extra.d-dir)

  (require 'init-load-tools)
  (require 'init-logging)
  (require 'init-proxy)
  (require 'init-straight)
  )

(let (;; temporarily increase `gc-cons-threshold' when loading to speed up startup.
      (gc-cons-threshold most-positive-fixnum)
      ;; Empty to avoid analyzing files when loading remote files.
      (file-name-handler-alist nil))



  (set-language-environment 'UTF-8)
  ;; ================== file history ==============
  (when my/enable-file-history-p
    (recentf-mode 1))
  ;;====================== search ===============
  (global-set-key (kbd "C-S-s") 'isearch-forward-symbol-at-point)

  (setq visible-bell 1)

  ;; ;;===========   menubar-mode    ==============================
  (menu-bar-mode 1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  (global-auto-revert-mode 1)
  ;; ============= Frame Title       ================
  (setq frame-title-format '(multiple-frames "%b"
					     ;; ("" "%b - Quick Emacs")
					     ("" "%b - Quick Emacs @ " system-name)))
  ;;=============== program-mode =====================
  (add-hook 'prog-mode-hook (lambda ()
                              (display-line-numbers-mode)
                              (subword-mode 1)))

  ;;=============== org mode =======================
  (setq org-edit-src-content-indentation 0)
  (setq org-src-preserve-indentation nil)
  (add-hook 'org-mode-hook #'org-indent-mode)
  (with-eval-after-load "org"
    (require 'org-indent))

  (global-set-key (kbd "M-o") #'other-window)
  (column-number-mode t)
  ;; ========== splash screen *GNU Emacs* buffer ============
  (setq inhibit-startup-screen t)


  (if (eq system-type 'windows-nt)
      (progn
        (set-face-attribute 'default nil :family "Consolas" :height 120)
        (set-face-attribute 'mode-line nil :family "Consolas" :height 120))
    )
  (defun duplicate-line()
    (interactive)
    (move-beginning-of-line 1)
    (kill-line)
    (yank)
    (open-line 1)
    (next-line 1)
    (yank)
    (back-to-indentation)
    )
  (global-set-key (kbd "M-Y") #'duplicate-line)

  (fido-vertical-mode +1)

  ;; (custom-set-faces
  ;;  ;; custom-set-faces was added by Custom.
  ;;  ;; If you edit it by hand, you could mess it up, so be careful.
  ;;  ;; Your init file should contain only one such instance.
  ;;  ;; If there is more than one, they won't work right.
  ;;  '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 120 :width normal))))
  ;;  '(mode-line ((t (:background "gray30" :box (:line-width 1 :color "red") :family "Consolas")))))

  (put 'upcase-region 'disabled nil)

  (global-set-key (kbd "M-i") #'completion-at-point)

  ;; ----------------- extra load path ---------------
  (when my/load-extra-p

    (require 'init-use-package)
    (require 'init-no-littering)
    (require 'init-compat)

    ;; ------------ doom mode line ---------------
    (when my/enable-file-history-p
      (require 'init-doom-modeline))

    ;; ------------ doom themes ----------------------
    (add-to-list 'load-path (expand-file-name "doom-themes" my/extra.d-dir))
    (add-to-list 'load-path (expand-file-name "doom-themes/extensions" my/extra.d-dir))

    (if (eq my/theme-to-load 'tsdh-dark)
        (load-theme my/theme-to-load t)
      (require 'init-doom-themes)
      ;; (use-package doom-themes
      ;;   :straight t
      ;;   :defer 3
      ;;   :config
      ;;   (setq doom-themes-enable-bold t ; if nil, bold is universally disabled
      ;;         doom-themes-enable-italic t) ; if nil, italics is universally disabled

      ;;   (load-theme my/theme-to-load t)

      ;;   ;; Enable flashing mode-line on errors
      ;;   (require 'doom-themes-ext-visual-bell)
      ;;   (doom-themes-visual-bell-config)

      ;;   ;; Corrects (and improves) org-mode's native fontification.
      ;;   (require 'doom-themes-ext-org)
      ;;   (doom-themes-org-config))
      )

    (require 'init-search)


    (when my/graphic-p
      (use-package init-unicode-fonts
        :demand t
        :config
        (unicode-fonts-setup))
      (require 'init-font)
      (my-load-font))


    ;; ------------- consult ----------------
    (use-package init-consult
      :demand t)

    (use-package init-vertico
      :demand t
      :config
      (fido-mode -1)
      :config
      (unless (boundp 'corfu-insert)
	(setq completion-in-region-function
	      (lambda (&rest args)
		(apply (if vertico-mode
			   #'consult-completion-in-region
			 #'completion--in-region)
		       args)))))


    ;; (use-package init-corfu
    ;;   :demand 2)
    (use-package init-embark
      :defer 2)
    ;; (require 'init-which-key)
    (use-package init-pyim
      :defer 2)
    (use-package init-liberime
      :defer 2)
    ;; (use-package init-all-the-icons
    ;;   :defer 2)
    ;; ------------ modes ----------------
    ;; .md, markdown
    (use-package init-markdown
      :mode ("\\.md\\'" . gfm-mode)
      :commands (gfm-mode markdown-mode))

    ;; .org, org-mode
    ;; (use-package init-org
    ;;   :mode ("\\.org\\'" . org-mode))


    ;; .pdf/.PDF, epub
    (use-package init-eaf
      :defer t
      :config
      (defun adviser-find-file (orig-fn file &rest args)
        (let ((fn (if my/use-eaf-p 'eaf-open orig-fn)))
	  (pcase (file-name-extension file)
	    ("pdf"  (apply fn file nil))
	    ("epub" (apply fn file nil))
	    (_      (apply orig-fn file args)))))
      (advice-add #'find-file :around #'adviser-find-file))

    (use-package init-major-modes
      :demand t)
    ;; (require 'init-major-modes)



    )

  ;; (toggle-debug-on-error)

  (global-unset-key (kbd "C-h r"))
  (global-set-key (kbd "C-h r r") (lambda ()
                                    (interactive)
                                    (load-file (expand-file-name "quick.emacs" my/conf-distro-dir))))
  (global-set-key (kbd "C-h t") (lambda ()
                                  (interactive)
                                  (if (functionp 'consult-theme)
                                      (call-interactively #'consult-theme)
                                    (call-interactively #'load-theme))))



  ;; (when (daemonp)
  (recentf-mode 1)
  (require 'init-font)
  (require 'init-ui)
  (require 'init-project)
  (require 'init-persp-mode)
  (require 'init-undo)


  (require 'persp-mode)

  ;; * `SPC i' prefix
  ;; revert buffer
  ;; (bind-key "SPC i r" 'revert-buffer 'xah-fly-command-map)
  ;; (bind-key "SPC i R" 'xah-open-last-closed 'xah-fly-command-map)
  ;; (bind-key "SPC i I" 'persp-switch-to-buffer 'xah-fly-command-map)
  ;; (bind-key "SPC i i" 'consult-project-buffer 'xah-fly-command-map)
  ;; (bind-key "SPC i k" 'bookmark-bmenu-list 'xah-fly-command-map)

  ;; code
  (require 'init-format)
  (require 'init-git)
  ;; (bind-key "SPC p v" 'magit 'xah-fly-command-map)
  ;; (bind-key "SPC e q" 'my/format-buffer-fn 'xah-fly-command-map)

  ;; ;; web
  ;; (bind-key "SPC w w" 'my/switch-default-browser 'xah-fly-command-map)

  ;; ;; lsp
  ;; (require 'init-lsp-toggle)
  ;; (bind-key "SPC w p" 'my-lsp-toggle 'xah-fly-command-map)

  ;; global tools
  (defvar my/global-tools-map
    (make-sparse-keymap)
    "keymap for global tools")


  (defvar my/server-keymap
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "s") #'server-edit)
      (define-key map (kbd "k") #'save-buffers-kill-emacs)
      (define-key map (kbd "d") #'server-start)
      map))

  (define-key my/global-tools-map (kbd "s") my/server-keymap)
  (define-key my/global-tools-map (kbd ". a") #'org-agenda)
  (define-key my/global-tools-map (kbd ". c") #'cfw:open-org-calendar)





  ;; (use-package org
  ;;   :config
  ;;   )
  (require 'init-org)
  (require 'init-exec-path-from-shell)

  ;; )

  (defvar my/quit-keymap
    (let ((map (make-sparse-keymap)))

      (define-key map (kbd "q") '("exit emacs" . save-buffers-kill-terminal))
      (define-key map (kbd "e") #'delete-window)
      (define-key map (kbd "f") #'delete-frame)
      (define-key map (kbd "w") #'quit-window)
      (define-key map (kbd "a") #'ace-delete-window)
      map)
    "my keymap for `quit'")

  (defun my/kill-emacs-save-or-server-edit ()
    " check if server done before save buffers and kill emacs"
    (interactive)
    (if (daemonp)
	(when-let ((server-already-done (string-equal "No server buffers remain to edit" (server-edit))))
          (save-buffers-kill-terminal))
      (save-buffers-kill-terminal)))
  ;; ----------- meow edit -----------------
  (use-package meow
    :straight t
    :commands (meow-quit meow-setup meow-global-mode)
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
       '("n" . meow-search)
       '("v" . meow-visit)

       '("\\" . my/meow-quit)
       ;; window
       '("`" . other-window)
       '("~" . other-frame)
       '("|" . split-window-right)

       ;; region
       '("=" . er/expand-region)

       ;; pair jump
       '("/" . xah-goto-matching-bracket) ;; "/"

       '("T" . set-mark-command)

       ;; '("M" . xah-backward-left-bracket) ;; "."
       ;; '(">" . xah-forward-right-bracket) ;; "m"

       ;; scroll
       '("<" . scroll-down-command)
       '(">" . scroll-up-command)

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

       (cons "q q"  'my/kill-emacs-save-or-server-edit)
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
       '("v" . meow-visit)
       '("w" . meow-mark-word)
       '("W" . meow-mark-symbol)
       '("x" . meow-line)
       '("X" . meow-goto-line)
       '("y" . meow-save)
       '("Y" . meow-sync-grab)
       '("z" . meow-pop-selection)
       '("Z" . xah-comment-dwim)
       '("'" . repeat)
       '("9" . recenter-top-bottom)
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
       '("f" . switch-to-buffer)
       '("H" . beginning-of-buffer)
       '("N" . end-of-buffer)
       '(";" . save-buffer)
       '("w" . xah-shrink-whitespaces)
       '("s" . kill-line)
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
      (meow-leader-define-key
       ;; window manage
       '("3" . delete-window)
       '("4" . split-window-below)

       )
      (meow-normal-define-key
       ;; window manage
       '("#" . delete-other-windows)
       '("$" . split-window-right)
       '("8" . other-window)
       )

      (meow-motion-overwrite-define-key
       ;; window manage
       '("#" . delete-other-windows)
       '("$" . split-window-right)
       '("8" . other-window))

      ;; (meow-normal-define-key
      ;;  '("[ [" . xah-beginning-of-line-or-block)
      ;;  '("] ]" . xah-end-of-line-or-block)
      ;;  )

      ;; (meow-normal-define-key
      ;;  '("M-N" . move-text-down)
      ;;  '("M-P" . move-twondert-up))

      (meow-leader-define-key
       (cons "." my/global-tools-map))
      (key-chord-define meow-insert-state-keymap "jk" #'meow-insert-exit)
      (global-set-key (kbd "<f7>") #'my/meow-insert-normal-toggle)
      )


    ;; (meow-setup)
    ;; (add-hook 'meow-global-mode #'meow-setup)
    )
  (require 'init-key-chord)
  (meow-setup)
  (meow-global-mode)


  (add-hook 'server-after-make-frame-hook #'meow-normal-mode)
  (add-hook 'server-after-make-frame-hook #'meow-setup)
  )
