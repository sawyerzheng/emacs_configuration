;; -*- coding: utf-8; -*-
(defvar my/enable-doom-modeline-p nil
  "if use `doom-modeline'")

;; theme
(defvar my/theme-to-load
  ;; 'doom-one
  'tsdh-dark
  "tsdh-dark, doom-one")
;;====================== search ===============
(global-set-key (kbd "C-S-s") 'isearch-forward-symbol-at-point)

(setq visible-bell 1)

;; ;;===========   menubar-mode    ==============================
(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

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

;; ----------------- extra load path ---------------
(defun my/enable-extra-loads ()

  (defvar my/conf-distro-dir (file-name-directory load-file-name)
    "folder to place most init files")

  (defvar my/extra.d-dir (expand-file-name "extra.d" my/conf-distro-dir)
    "folder to my manualy downloaded elisp packages")

  (add-to-list 'load-path my/conf-distro-dir)
  (add-to-list 'load-path my/extra.d-dir)

  (require 'init-load-tools)
  (require 'init-straight)
  (require 'init-proxy)
  (require 'init-use-package)

  ;; ------------ doom mode line ---------------
  (use-package doom-modeline
    :if my/enable-doom-modeline-p
    :straight t
    :config
    (doom-modeline-mode 1))

  ;; ------------ doom themes ----------------------
  (add-to-list 'load-path (expand-file-name "doom-themes" my/extra.d-dir))
  (add-to-list 'load-path (expand-file-name "doom-themes/extensions" my/extra.d-dir))

  (if (eq my/theme-to-load 'tsdh-dark)
      (load-theme my/theme-to-load t)
    (use-package doom-themes
      :straight t
      :config
      (setq doom-themes-enable-bold t ; if nil, bold is universally disabled
            doom-themes-enable-italic t) ; if nil, italics is universally disabled

      (load-theme my/theme-to-load t)

      ;; Enable flashing mode-line on errors
      (require 'doom-themes-ext-visual-bell)
      (doom-themes-visual-bell-config)

      ;; Corrects (and improves) org-mode's native fontification.
      (require 'doom-themes-ext-org)
      (doom-themes-org-config)))


  (require 'init-unicode-fonts)
  (require 'init-font)
  (my-load-font)
  ;; ------------- consult ----------------
  (require 'init-consult)
  ;; (fido-vertical-mode -1)
  (fido-mode -1)
  (require 'init-vertico)
  (require 'init-corfu)
  (require 'init-embark)
  ;; (require 'init-which-key)
  ;; ----------- xah fly keys -----------------
  (use-package xah-fly-keys
    :straight (xah-fly-keys :type git :host github :repo "xahlee/xah-fly-keys")
    :init
    (setq xah-fly-use-control-key nil)
    (setq xah-fly-use-meta-key nil)
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
    (define-key xah-fly-command-map (kbd "<escape>") #'xah-fly-mode-toggle)
    (define-key xah-fly-command-map (kbd "<f7>") #'xah-fly-mode-toggle)
    (define-key xah-fly-insert-map (kbd "<escape>") #'xah-fly-mode-toggle)
    (define-key xah-fly-insert-map (kbd "<f7>") #'xah-fly-mode-toggle)

    (define-key xah-fly-command-map (kbd "SPC p") project-prefix-map)

    (define-key xah-fly-command-map (kbd "SPC q") my/xah-quit-keymap)
    (define-key xah-fly-command-map (kbd "q") my/xah-search-keymap)
    (define-key xah-fly-command-map (kbd "SPC i r") #'revert-buffer)
    )



  ;; * enable xah-fly-keys
  (xah-fly-keys)
  ;; --------------- end xah fly keys ---------------
  )

;; (toggle-debug-on-error)
(my/enable-extra-loads)
