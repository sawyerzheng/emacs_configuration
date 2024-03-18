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
    ;; ----------- xah fly keys -----------------
    (use-package init-key-chord)
    (use-package xah-fly-keys
      :straight (xah-fly-keys :type git :host github :repo "xahlee/xah-fly-keys")
      :init
      (setq xah-fly-use-control-key nil)
      (setq xah-fly-use-meta-key nil)
      (defun my/eaf-mode-p ()
        "if in a eaf-mode or eaf derived mode"
        (interactive)
        (derived-mode-p 'eaf-mode))

      (defun my/xah-i-key-command ()
        "xa up key `i'"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-scroll_down))
              (t (previous-line))))

      (defun my/xah-k-key-command ()
        "xah down key `k'"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-scroll_up))
              (t (next-line))))

      (defun my/xah-j-key-command ()
        "xah left key `j'"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-scroll_left))
              (t (backward-char))))

      (defun my/xah-l-key-command ()
        "xah left key `l'"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-scroll_right))
              (t (forward-char))))

      (defun my/xah-I-key-command ()
        "xah left key `I', scroll page up"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-scroll_down_page))
              (t (scroll-down-command))))

      (defun my/xah-K-key-command ()
        "xah left key `K', scroll page down"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-scroll_up_page))
              (t (scroll-up-command))))

      (defun my/xah-begin-key-command ()
        "xah begin key `SPC h'"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-insert_or_scroll_to_begin))
              (t (beginning-of-buffer))))

      (defun my/xah-end-key-command ()
        "xah end key `SPC n'"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-insert_or_scroll_to_bottom))
              (t (end-of-buffer))))

      (defun my/xah-line-or-block-begin-key-command ()
        "xah line/block end key `h'"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-history_backward))
              (t (xah-beginning-of-line-or-block))))

      (defun my/xah-line-or-block-end-key-command ()
        "xah line/block end key `h'"
        (interactive)
        (cond ((my/eaf-mode-p) (eaf-py-proxy-history_forward))
              (t (xah-end-of-line-or-block))))

      :defines (xah-fly-command-map)
      :commands (xah-fly-keys)
      ;; :hook (my/startup . xah-fly-keys)
      ;; :hook (my/startup . (lambda () (require 'xah-fly-keys) (xah-fly-keys +1)))

      ;; local keymap binding
      ;; :hook ((prog-mode org-mode) . (lambda ()
      ;;                                 (bind-key "SPC b" (my/local-keymap) 'xah-fly-command-map)))
      :config
      (use-package init-key-chord
        :config
        (setq key-chord-two-keys-delay 0.05)
        (setq key-chord-safety-interval-forward 0.1)
        :demand t)

      (key-chord-define-global "jk" #'xah-fly-mode-toggle)
      ;; (key-chord-define xah-fly-insert-map "jk" #'xah-fly-command-mode-activate)
      ;; (key-chord-define xah-fly-insert-map "kl" (kbd "C-g"))


      (defun my/keyboard-quit ()
	(interactive)
	(cond
	 ((derived-mode-p 'minibuffer-mode)
	  (call-interactively #'minibuffer-keyboard-quit))
	 ((derived-mode-p 'isearch-mode)
	  (call-interactively #'isearch-abort))
	 ((derived-mode-p 'blink-search-mode)
	  (call-interactively #'blink-search-quit))
	 (t
	  ;; (execute-kbd-macro (read-kbd-macro "C-g"))
	  (my/exeucte-key-macro "C-g")
	  )))

      (bind-key "<escape>" nil xah-fly-shared-map)
      (bind-key "<escape>" nil xah-fly-command-map)
      (bind-key "<escape>" nil xah-fly-insert-map)
      (bind-key "<escape>" #'my/keyboard-quit)
      ;; (global-set-key (kbd "<escape>") (kbd "C-g"))

      :bind (:map xah-fly-command-map
                  ("<f7>" . xah-fly-mode-toggle)
                  )
      :bind (:map xah-fly-insert-map
                  ("<f7>" . xah-fly-mode-toggle)
                  )

      :bind (:map xah-fly-command-map
                  ([remap recentf-open-files] . consult-recent-file)
                  ("SPC SPC" . recenter-top-bottom) ;; unmap xah's SPC p to SPC b
                  ;; ("SPC p" . projectile-command-map)
                  ;; ("SPC p" . project-prefix-map)
                  ("SPC <tab>" . persp-key-map)

                  ;; remap navigation key
                  ("i" . my/xah-i-key-command)
                  ("k" . my/xah-k-key-command)
                  ("j" . my/xah-j-key-command)
                  ("l" . my/xah-l-key-command)
                  ;; scroll this window
                  ("K" . my/xah-K-key-command)
                  ("I" . my/xah-I-key-command)
                  ;; scroll other window
                  ("M-K" . scroll-other-window)
                  ("M-I" . scroll-other-window-down)

                  ;; buffer begin/end
                  ("SPC h" . my/xah-begin-key-command)
                  ("SPC n" . my/xah-end-key-command)

                  ;; block or line begin/end
                  ("h" . my/xah-line-or-block-begin-key-command)
                  (";" . my/xah-line-or-block-end-key-command)

                  ("Y" . undo-redo)
                  ;; recenter
                  ("g" . recenter-top-bottom)
                  ;; exit window
                  ("\\" . my/meow-quit)
                  ;; embark
                  ("SPC j e" . embark-act)
                  )


      :config
      (defvar my/xah-quit-keymap
        (let ((map (make-sparse-keymap)))

          (define-key map (kbd "q") '("exit emacs" . save-buffers-kill-terminal))
          (define-key map (kbd "e") #'delete-window)
          (define-key map (kbd "f") #'delete-frame)
          (define-key map (kbd "w") #'quit-window)
          (define-key map (kbd "a") #'ace-delete-window)
          map)
        "my keymap for `quit'")

      (defvar my/xah-search-keymap
        (let ((map (make-sparse-keymap)))
          (define-key map (kbd "s") #'consult-line)
          (define-key map (kbd "f") '("find file path" . consult-find))
          (define-key map (kbd "p") '("find file content" . consult-ripgrep))
          (define-key map (kbd "i") #'(lambda ()
                                        (interactive)
                                        (cond
                                         ((eq major-mode 'org-mode)
                                          (consult-org-heading))
                                         ((or (derived-mode-p 'outline-mode)
                                              (member major-mode '(markdown-mode gfm-mode)))
                                          (consult-outline))
                                         ((derived-mode-p 'compilation-mode)
                                          (consult-compile-error))
                                         (t
                                          (consult-imenu)))))
          (define-key map (kbd "I") #'consult-imenu-multi)

          ;; * docsets or devdocs
          (define-key map (kbd "o") #'+lookup/online)
          (define-key map (kbd "D") #'devdocs-dwim)
          (define-key map (kbd "d") #'my/counsel-dash-at-point)
          (define-key map (kbd "z") #'zeal-at-point)

          ;; * dictionary
          (define-key map (kbd "y") #'my-youdao-dictionary-search-at-point)
          (define-key map (kbd "Y") #'fanyi-dwim2)
          (define-key map (kbd "b") #'popweb-dict-bing-pointer)
          (define-key map (kbd "v") #'popweb-dict-bing-input)


          ;; * char, word jump
          ;; (define-key map (kbd "j") #'ace-pinyin-jump-word)
          (define-key map (kbd "j") #'avy-goto-word-1)
          (define-key map (kbd "k") #'avy-goto-char)
          (define-key map (kbd "2") #'avy-goto-char-2)

          ;; * line jump
          (define-key map (kbd "l") #'avy-goto-line)
          (define-key map (kbd "q") #'consult-line)

          ;; embark
          (define-key map (kbd ".") #'embark-act)

          ;; C-g
          (define-key map (kbd "g") #'keyboard-quit)
          map)
        "keymap for search")

      :config
      (define-key xah-fly-command-map (kbd "<f7>") #'xah-fly-mode-toggle)
      (define-key xah-fly-insert-map (kbd "<f7>") #'xah-fly-mode-toggle)

      (define-key xah-fly-command-map (kbd "SPC p") project-prefix-map)

      (define-key xah-fly-command-map (kbd "SPC q") my/xah-quit-keymap)
      (define-key xah-fly-command-map (kbd "q") my/xah-search-keymap)
      (define-key xah-fly-command-map (kbd "SPC i r") #'revert-buffer)

      (key-chord-define xah-fly-insert-map "df" #'xah-fly-command-mode-activate)
      )



    ;; * enable xah-fly-keys
    (xah-fly-keys)
    ;; --------------- end xah fly keys ---------------
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
  (bind-key "SPC i r" 'revert-buffer 'xah-fly-command-map)
  (bind-key "SPC i R" 'xah-open-last-closed 'xah-fly-command-map)
  (bind-key "SPC i I" 'persp-switch-to-buffer 'xah-fly-command-map)
  (bind-key "SPC i i" 'consult-project-buffer 'xah-fly-command-map)
  (bind-key "SPC i k" 'bookmark-bmenu-list 'xah-fly-command-map)

  ;; code
  (require 'init-format)
  (require 'init-git)
  (bind-key "SPC p v" 'magit 'xah-fly-command-map)
  (bind-key "SPC e q" 'my/format-buffer-fn 'xah-fly-command-map)

  ;; web
  (bind-key "SPC w w" 'my/switch-default-browser 'xah-fly-command-map)

  ;; lsp
  (require 'init-lsp-toggle)
  (bind-key "SPC w p" 'my-lsp-toggle 'xah-fly-command-map)

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

  (define-key xah-fly-command-map (kbd "SPC .") my/global-tools-map)

  ;; * undo
  (bind-key "y" #'undo-fu-only-undo 'xah-fly-command-map)
  (bind-key "Y" #'undo-fu-only-redo 'xah-fly-command-map)

  (add-hook 'server-after-make-frame-hook #'xah-fly-command-mode-activate)

  ;; (use-package org
  ;;   :config
  ;;   )
  (require 'init-org)
  (require 'init-exec-path-from-shell)

  ;; )

  )
