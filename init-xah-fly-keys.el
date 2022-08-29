(use-package xah-fly-keys
  :straight (xah-fly-keys :type git :host github :repo "xahlee/xah-fly-keys")
  ;; :after (consult)
  :init
  (setq xah-fly-use-control-key nil)
  (setq xah-fly-use-meta-key nil)
  :defines (xah-fly-command-map)
  :commands (xah-fly-keys)
  :hook (after-init . xah-fly-keys)
  ;; :hook (after-init . (lambda () (require 'xah-fly-keys) (xah-fly-keys +1)))

  ;; local keymap binding
  ;; :hook ((prog-mode org-mode) . (lambda ()
  ;;                                 (bind-key "SPC b" (my/local-keymap) 'xah-fly-command-map)))

  :bind (:map xah-fly-command-map
              ("<escape>" . xah-fly-mode-toggle)
              ("<f7>" . xah-fly-mode-toggle)
              )
  :bind (:map xah-fly-insert-map
              ("<escape>" . xah-fly-mode-toggle)
              ("<f7>" . xah-fly-mode-toggle)
              )

  :bind (:map xah-fly-command-map
              ([remap recentf-open-files] . consult-recent-file)
              ("SPC SPC" . recenter-top-bottom) ;; unmap xah's SPC p to SPC b
              ;; ("SPC p" . projectile-command-map)
              ;; ("SPC p" . project-prefix-map)
              ("SPC <tab>" . persp-key-map)
              )
  :config
  ;; open new line
  (bind-key "O" #'open-newline-above 'xah-fly-command-map)
  (bind-key "C-o" #'open-newline-below 'xah-fly-command-map)

  ;; move text
  (bind-key "J" #'move-text-up 'xah-fly-command-map)
  (bind-key "L" #'move-text-down 'xah-fly-command-map)

  ;; open external
  (bind-key [remap xah-open-in-external-app] 'my/open-file-externally)
  ;; use `project.el'
  (bind-key "SPC p" project-prefix-map xah-fly-command-map)


  ;; (global-set-key [remap projectile-command-map] project-prefix-map)
  :bind (:map xah-fly-command-map
              ;; scroll this window
              ("K" . scroll-up-command)
              ("I" . scroll-down-command)
              ;; scroll other window
              ;; ("M-J" . scroll-other-window)
              ;; ("M-L" . scroll-other-window-down)

              ("M-K" . scroll-other-window)
              ("M-I" . scroll-other-window-down)
              )
  :config
  (xah-fly-keys-set-layout "qwerty")
  ;; (global-set-key (kbd "<escape>") 'xah-fly-mode-toggle)
  ;; (global-set-key (kbd "<f7>") 'xah-fly-mode-toggle)
  (defun my/activate-xah-fly-command-mode ()
    (interactive)
    (if (null xah-fly-keys)
        (xah-fly-command-mode-activate)))
  ;; (define-key xah-fly-insert-map    (kbd "M-f") 'my/activate-xah-fly-command-mode)
  (defvar my/xah-command-activate-key "M-f"
    "key to activate xah fly command mode")
  (defun my/xah-fly-rebind-keys ()
    (local-unset-key (kbd my/xah-command-activate-key))
    (local-set-key (kbd my/xah-command-activate-key) #'xah-fly-command-mode-activate))
  ;; (add-hook 'xah-fly-insert-mode-activate-hook #'my/xah-fly-rebind-keys)
  ;; (define-key xah-fly-insert-map (kbd "M-f") 'xah-fly-command-mode-activate)
  ;; (define-key xah-fly-insert-map (kbd "\\") 'xah-fly-command-mode-activate)
  ;; (add-hook 'magit-status-mode-hook #'xah-fly-insert-mode-activate)


  (require 'init-one-key)
  ;; (require 'xah-fly-keys)
  (defun my/iedit-smart-trigger ()
    (interactive)
    (cond (isearch-mode (iedit-mode-from-isearch))
          ;; (esc (iedit-execute-last-modification))
          ;; (help (iedit-mode-toggle-on-function))
          (t (iedit-mode))))

  (require 'init-smartparens)
  (one-key-create-menu
   "List-Jump"
   '(
     ;; function jump
     (("a" . "ahead of function") . beginning-of-defun)
     (("e" . "end of function") . end-of-defun)
     (("w" . "go up of code") . (lambda ()
                                  (interactive)
                                  (cond
                                   ((eq major-mode 'python-mode) (python-nav-backward-up-list))
                                   (t (backward-up-list)))))
     (("d" . "go down of code") . (lambda ()
                                    (interactive)
                                    (cond
                                     ((eq major-mode 'python-mode) (sp-down-sexp))
                                     (t (down-list)))))
     ;; "", () pair and sexp jump
     (("[" . "previous sexp ") . sp-backward-sexp)
     (("]" . "next sexp") . sp-forward-sexp)
     (("i" . "up sexp") . sp-up-sexp)

     ;; jump just (), {}, [], 没有： xah-fly-keys: /, m, . 好用
     (("p" . "prev bracket") . backward-list)
     (("n" . "next bracket") . forward-list)
     (("k" . "down bracket") . down-list)


     ;; iedit
     ((";" . "iedit-mode") . my/iedit-smart-trigger)

     ;; open at cursor
     ;; (("o" . ))
     )
   t)
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
    (make-sparse-keymap)
    "keymap for search")
  (let ((map my/xah-search-keymap))
    (require 'init-consult)
    (require 'init-dictionary)
    (define-key map (kbd "s") #'+default/search-buffer)
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
    (define-key map (kbd "q") #'+default/search-buffer)

    ;; embark
    (define-key map (kbd ".") #'embark-act)

    ;; C-g
    (define-key map (kbd "g") #'keyboard-quit))

  (bind-key "SPC q" my/xah-quit-keymap 'xah-fly-command-map)
  ;; rebind original `SPC q' to `SPC e q'
  (bind-key "q" #'(lambda (&optional args)
                    (interactive)
                    (cond ((derived-mode-p 'prog-mode)
                           (funcall-interactively #'format-all-buffer))
                          (t
                           (ignore-errors
                             (funcall-interactively #'xah-reformat-lines))))) 'xah-fly-Lp2p1-key-map)

  (bind-key "w" 'xah-fill-or-unfill 'xah-fly-Lp2p1-key-map)
  ;; align
  (bind-key "a" #'ialign 'xah-fly-Lp2p1-key-map)
  ;; window resize and jump
  ;; (bind-key)
  (bind-key "o" #'resize-window 'xah-fly-Lp2p1-key-map)

  ;; =[= for jump
  (bind-key "[" 'one-key-menu-list-jump 'xah-fly-command-map)
  (bind-key "] ]" 'sp-forward-sexp 'xah-fly-command-map)
  ;; =q= for search(query)
  (bind-key "q" my/xah-search-keymap 'xah-fly-command-map)
  ;; (bind-key)
  (bind-key "'" #'one-key-menu-thing-edit 'xah-fly-command-map)

  ;; * `SPC i' prefix
  ;; revert buffer
  (bind-key "r" 'revert-buffer 'xah-fly-Rp2p1-key-map)
  (bind-key "R" 'xah-open-last-closed 'xah-fly-Rp2p1-key-map)
  (bind-key "I" 'persp-switch-to-buffer 'xah-fly-Rp2p1-key-map)
  (bind-key "i" 'consult-project-buffer 'xah-fly-Rp2p1-key-map)
  (bind-key "k" 'bookmark-bmenu-list 'xah-fly-Rp2p1-key-map)

  ;; major mode hydra
  (bind-key "SPC b" #'major-mode-hydra 'xah-fly-command-map)
  ;; (bind-key "SPC")

  ;; try to change cursor backgroud color between insert and command mode
  ;; (add-hook 'xah-fly-insert-mode-activate-hook #'(lambda ()
  ;;                                                  (modify-all-frames-parameters (list (cons 'cursor-type 'box)))
  ;;                                                  (set-face-background 'cursor "white")))
  ;; (add-hook 'xah-fly-command-mode-activate-hook #'(lambda ()
  ;;                                                   (set-face-background 'cursor "#51afef")))

  ;; mark tool
  (defvar my/mark-thing-map
    nil
    "mark thing keymap")
  (setq my/mark-thing-map
        (let* ((map (make-sparse-keymap)))
          (require 'expand-region)
          (define-key map (kbd "d") #'mark-defun)
          (define-key map (kbd "w") #'xah-extend-selection)
          (define-key map (kbd "s") #'xah-select-line) ;; sentence(line)
          (define-key map (kbd "e") #'er/expand-region)

          ;; select just one thing
          (define-key map (kbd "f") #'sp-select-next-thing)
          (define-key map (kbd "b") #'sp-select-previous-thing-exchange)

          ;; iedit
          (define-key map (kbd "a") #'my/iedit-smart-trigger)
          ;; recover jump map
          (define-key map (kbd "]") #'sp-forward-sexp)
          map))
  (bind-key "]" my/mark-thing-map 'xah-fly-command-map)

  ;; eaf fix
  ;; (with-eval-after-load 'eaf
  ;;   (add-hook 'eaf-mode-hook #'xah-fly-insert-mode-activate))

  ;; iedit fix
  (with-eval-after-load 'iedit
    (add-hook 'iedit-mode-hook #'xah-fly-insert-mode-activate))

  ;; multiple-cursors fix
  (with-eval-after-load 'multiple-cursors
    (add-hook 'multiple-cursors-mode-hook #'xah-fly-insert-mode-activate))
  ;; magit
  (with-eval-after-load 'magit
    (add-hook 'magit-mode-hook #'xah-fly-insert-mode-activate)
    (add-hook 'magit-status-mode-hook #'xah-fly-insert-mode-activate))

  ;; vc-mode
  (bind-key "SPC v" 'vc-prefix-map #'xah-fly-command-map)

  ;; global tools
  (defvar my/global-tools-map
    (make-sparse-keymap)
    "keymap for global tools")


  ;; (autoload 'my/eaf-keymap "init-eaf")

  (define-key my/global-tools-map (kbd "e") my/eaf-keymap)

  (define-key xah-fly-command-map (kbd "SPC .") my/global-tools-map)

  ;; * undo
  (bind-key "y" #'undo-fu-only-undo 'xah-fly-command-map)
  (bind-key "Y" #'undo-fu-only-redo 'xah-fly-command-map)
  )


(provide 'init-xah-fly-keys)
