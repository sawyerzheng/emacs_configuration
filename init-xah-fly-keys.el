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
  :bind (:map xah-fly-command-map
              ("<escape>" . xah-fly-mode-toggle))
  :bind (:map xah-fly-insert-map
              ("<escape>" . xah-fly-mode-toggle))

  :bind (:map xah-fly-command-map
              ([remap recentf-open-files] . consult-recent-file)
              ("SPC SPC" . recenter-top-bottom) ;; unmap xah's SPC p to SPC b
              ;; ("SPC p" . projectile-command-map)
              ;; ("SPC p" . project-prefix-map)
              ("SPC <tab>" . persp-key-map)

              )
  :config
  ;; use `project.el'
  (bind-key "SPC p" project-prefix-map xah-fly-command-map)
  ;; (global-set-key [remap projectile-command-map] project-prefix-map)
  :bind (:map xah-fly-command-map
              ;; scroll this window
              ("K" . scroll-up-command)
              ("I" . scroll-down-command)
              ;; scroll other window
              ("M-J" . scroll-other-window)
              ("M-L" . scroll-other-window-down))
  :config
  (xah-fly-keys-set-layout "qwerty")
  ;; (global-set-key (kbd "<escape>") 'xah-fly-mode-toggle)
  (global-set-key (kbd "<f7>") 'xah-fly-mode-toggle)
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
     (("u" . "go up of code") . (lambda ()
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

     ;; select just one thing
     (("s" . "select next or current thing") . sp-select-next-thing)
     (("S" . "select previous or current thing")  . sp-select-previous-thing-exchange)

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
      map)
    "my keymap for `quit'")

  (defvar my/xah-search-keymap
    (let ((map (make-sparse-keymap)))
      (require 'init-consult)
      (require 'init-dictionary)
      (define-key map (kbd "s") #'+default/search-buffer)
      (define-key map (kbd "f") '("find file path" . consult-find))
      (define-key map (kbd "p") '("find file content" . consult-ripgrep))
      (define-key map (kbd "i") #'consult-imenu)
      (define-key map (kbd "I") #'consult-imenu-multi)
      (define-key map (kbd "o") #'+lookup/online)

      (define-key map (kbd "y") #'my-youdao-dictionary-search-at-point)
      (define-key map (kbd "d") #'fanyi-dwim2)
      (define-key map (kbd "j") #'ace-pinyin-jump-word)
      (define-key map (kbd "q") #'+default/search-buffer)

      map)
    "keymap for search")

  (bind-key "SPC q" my/xah-quit-keymap 'xah-fly-command-map)
  ;; rebind original `SPC q' to `SPC e q'
  (bind-key "q" 'xah-reformat-lines 'xah-fly-Lp2p1-key-map)
  (bind-key "w" 'xah-fill-or-unfill 'xah-fly-Lp2p1-key-map)
  ;; =[= for jump
  (bind-key "[" 'one-key-menu-list-jump 'xah-fly-command-map)
  (bind-key "] ]" 'sp-forward-sexp 'xah-fly-command-map)
  ;; =q= for search(query)
  (bind-key "q" my/xah-search-keymap 'xah-fly-command-map)
  ;; (bind-key)
  (bind-key "'" #'one-key-menu-thing-edit 'xah-fly-command-map)
  )


(provide 'init-xah-fly-keys)
