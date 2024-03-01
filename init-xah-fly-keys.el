(use-package xah-fly-keys
  :straight (xah-fly-keys :type git :host github :repo "xahlee/xah-fly-keys")
  :init
  (setq xah-fly-use-control-key nil)
  (setq xah-fly-use-meta-key nil)
  ;; (global-set-key (kbd "M-8") #'xah-fly-mode-toggle)
  (add-hook 'xah-fly-keys-hook (lambda ()
                                 (add-hook 'winum-mode-hook (lambda () (define-key winum-keymap (kbd "M-8") nil)))))
  :defines (xah-fly-command-map)
  :commands (xah-fly-keys)
  :hook (my/startup . xah-fly-keys)
  :bind (:map xah-fly-command-map
              ("f" . xah-fly-mode-toggle)
              ("F" . xah-fly-mode-toggle)
              ;; ("<escape>" . xah-fly-mode-toggle)
              ("<f7>" . xah-fly-mode-toggle)
              ;; ("M-8" . xah-fly-insert-mode-activate)
              )
  :bind (:map xah-fly-insert-map
              ;; ("<escape>" . xah-fly-mode-toggle)
              ("<f7>" . xah-fly-mode-toggle)
              ;; ("M-8" . xah-fly-command-mode-activate)
              )

  :bind (:map xah-fly-command-map
              ("SPC F" . persp-switch-to-buffer))

  :bind (:map xah-fly-command-map
              ("g" . recenter-top-bottom)
              ("G" . xah-delete-current-text-block)
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

              ;; cut or kill eaf tab
              ("x" . my/xah-x-key-command)

              ;; explorer
              ("SPC M" . explorer)
              ("SPC i m" . explorer)
              )

  :hook ((iedit-mode
          multiple-cursors-mode
          magit-status-mode
          magit-mode
          ement-room-mode
          mu4e-main-mode
          blink-search-mode) . xah-fly-insert-mode-activate))


;; * jump commands
(defun my/xah-i-key-command ()
  "xa up key `i'"
  (interactive)
  (cond ((my/eaf-mode-p)
         (if (boundp #'eaf-py-proxy-scroll_down)
             (eaf-py-proxy-scroll_down)
           (my/exeucte-key-macro "<up>")))
        ((my/minibuffer-mode-p)
         (my/exeucte-key-macro "<up>"))
        (t (previous-line))))

(defun my/xah-k-key-command ()
  "xah down key `k'"
  (interactive)
  (cond ((my/eaf-mode-p)
         (if (boundp #'eaf-py-proxy-scroll_up) (eaf-py-proxy-scroll_up) (my/exeucte-key-macro "<down>")))
        ((my/minibuffer-mode-p) (my/exeucte-key-macro "<down>"))
        (t (next-line))))

(defun my/xah-j-key-command ()
  "xah left key `j'"
  (interactive)
  (cond ((my/eaf-mode-p)
         (if (boundp #'eaf-py-proxy-scroll_left) (eaf-py-proxy-scroll_left) (my/exeucte-key-macro "<left>")))
        (t (backward-char))))

(defun my/xah-l-key-command ()
  "xah left key `l'"
  (interactive)
  (cond ((my/eaf-mode-p) (if (boundp #'eaf-py-proxy-scroll_right) (eaf-py-proxy-scroll_right) (my/exeucte-key-macro "<right>")))
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

(defun my/xah-x-key-command ()
  "xah left key `K', scroll page down"
  (interactive)
  (cond ((my/eaf-mode-p) (eaf-py-proxy-insert_or_close_buffer))
        (t (xah-cut-line-or-region))))

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


;; * layout basic
(require 'xah-fly-keys)
(xah-fly-keys-set-layout "qwerty")

(require 'init-key-chord)
(key-chord-define-global "kj" #'xah-fly-mode-toggle)
(key-chord-define xah-fly-insert-map "kj" #'xah-fly-command-mode-activate)
(key-chord-define xah-fly-insert-map "KJ" #'xah-fly-command-mode-activate)
;; (key-chord-define xah-fly-insert-map "df" #'god-execute-with-current-bindings)
(key-chord-define xah-fly-insert-map "kl" #'god-execute-with-current-bindings)

;; * ctrl prefix keys disable
(defun my/disable-ctrl-keys ()
  (interactive)
  ;; (global-unset-key (kbd "C-n"))
  ;; (global-unset-key (kbd "C-p"))
  ;; (global-unset-key (kbd "C-b"))
  ;; (global-unset-key (kbd "C-f"))
  ;; (global-unset-key (kbd "C-e"))
  ;; (global-unset-key (kbd "C-a"))
  ;; (global-unset-key (kbd "C-h f"))
  ;; (global-unset-key (kbd "C-h v"))
  ;; (global-unset-key (kbd "C-h k"))
  ;; (global-unset-key (kbd "C-M-i"))
  )
(my/disable-ctrl-keys)

;; * disable self-insert-keys
(defun my/key-disabled-echo ()
  (interactive)
  (message "disabled key stroke"))

(defun my/disable-self-insert-keys ()
  (interactive)
  (dolist (map (list xah-fly-insert-map) nil)
    (dolist (key (list "[" "{" "\"" "+" "_" "*"))
      (define-key map (kbd key) #'my/key-disabled-echo))
    ;; (define-key map (kbd "\"") #'my/key-disabled-echo)
    ;; (define-key map (kbd "{") #'my/key-disabled-echo)
    ))

(defun my/enable-self-insert-keys ()
  (interactive)
  (dolist (map (list xah-fly-insert-map) nil)
    (dolist (key (list "[" "{" "\"" "+" "_" "*"))
      (define-key map (kbd key) #'self-insert-command))
    ;; (define-key map (kbd "\"") #'my/key-disabled-echo)
    ;; (define-key map (kbd "{") #'my/key-disabled-echo)
    ))

;; (my/disable-self-insert-keys)

;; * character inserting
(setq xah-unicode-list (append
                        xah-unicode-list
                        '(("mu μ")
                          ("celsius ℃")
                          ("delta δ")
                          ("Delta Δ")
                          ("epsilon ε")
                          ("sigma σ")
                          ("Sigma Σ")
                          ("lambda λ")
                          ("zero-width-space ​")
                          )
                        ))
;; (define-key xah-fly-command-map (kbd "SPC d SPC") '("zero width space" . (lambda () (interactive) (insert-char ?​))))
(define-key xah-fly-command-map (kbd "SPC d '") '(":" . (lambda () (interactive) (insert "\""))))
(define-key xah-fly-command-map (kbd "SPC d ,") '("<" . (lambda () (interactive) (insert "<"))))
(define-key xah-fly-command-map (kbd "SPC d .") '(">" . (lambda () (interactive) (insert ">"))))
(define-key xah-fly-command-map (kbd "SPC d /") '("?" . (lambda () (interactive) (insert "?"))))
(define-key xah-fly-command-map (kbd "SPC d ;") '(":" . (lambda () (interactive) (insert ":"))))
(define-key xah-fly-command-map (kbd "SPC d \\") '("|" . (lambda () (interactive) (insert "|"))))
(define-key xah-fly-command-map (kbd "SPC d [") '("{" . (lambda () (interactive) (insert "{"))))
(define-key xah-fly-command-map (kbd "SPC d ]") '("}" . (lambda () (interactive) (insert "}"))))
(define-key xah-fly-command-map (kbd "SPC d =") '("+" . (lambda () (interactive) (insert "+"))))
(define-key xah-fly-command-map (kbd "SPC d -") '("_" . (lambda () (interactive) (insert "_"))))
(define-key xah-fly-command-map (kbd "SPC d 0") '(")" . (lambda () (interactive) (insert ")"))))
(define-key xah-fly-command-map (kbd "SPC d 9") '("(" . (lambda () (interactive) (insert "("))))
(define-key xah-fly-command-map (kbd "SPC d 8") '("*" . (lambda () (interactive) (insert "*"))))
(define-key xah-fly-command-map (kbd "SPC d 7") '("&" . (lambda () (interactive) (insert "&"))))
(define-key xah-fly-command-map (kbd "SPC d 6") '("^" . (lambda () (interactive) (insert "^"))))
(define-key xah-fly-command-map (kbd "SPC d 5") '("%" . (lambda () (interactive) (insert "%"))))
(define-key xah-fly-command-map (kbd "SPC d 4") '("$" . (lambda () (interactive) (insert "$"))))
(define-key xah-fly-command-map (kbd "SPC d 3") '("#" . (lambda () (interactive) (insert "#"))))
(define-key xah-fly-command-map (kbd "SPC d 2") '("@" . (lambda () (interactive) (insert "@"))))
(define-key xah-fly-command-map (kbd "SPC d 1") '("!" . (lambda () (interactive) (insert "!"))))
(define-key xah-fly-command-map (kbd "SPC d `") '("~" . (lambda () (interactive) (insert "~"))))

(bind-key  "SPC d e" #'sp-rewrap-sexp 'xah-fly-command-map)
(defvar my/insert-char-map (make-sparse-keymap)
  "keymap for insert shift + char chars")


(let ((map my/insert-char-map))
  (define-key map (kbd "f") '(";" . (lambda () (interactive) (insert ";"))))
  ;; (define-key map (kbd "SPC") '("zero width space" . (lambda () (interactive) (insert-char ?​))))
  ;; (define-key xah-fly-insert-map (kbd "'") '("\"" . (lambda () (interactive) (insert "\""))))

  (define-key map (kbd "'") '("\"" . xah-insert-ascii-double-quote))
  (define-key map (kbd ",") '("<" . (lambda () (interactive) (insert "<"))))
  (define-key map (kbd ".") '(">" . (lambda () (interactive) (insert ">"))))
  (define-key map (kbd "/") '("?" . (lambda () (interactive) (insert "?"))))
  ;; (define-key map (kbd ";") '(":" . (lambda () (interactive) (insert ":"))))
  (define-key map (kbd ";") '(";" . (lambda () (interactive) (insert ";"))))
  (define-key map (kbd "\\") '("|" . (lambda () (interactive) (insert "|"))))
  ;; (define-key map (kbd "[") '("{" . (lambda () (interactive) (insert "{"))))
  (define-key map (kbd "[") '("{" . xah-insert-brace))
  (define-key map (kbd "]") '("}" . (lambda () (interactive) (insert "}"))))
  (define-key map (kbd "=") '("+" . (lambda () (interactive) (insert "+"))))
  (define-key map (kbd "-") '("_" . (lambda () (interactive) (insert "_"))))
  (define-key map (kbd "0") '(")" . (lambda () (interactive) (insert ")"))))
  ;; (define-key map (kbd "9") '("(" . (lambda () (interactive) (insert "("))))
  (define-key map (kbd "9") '("(" . xah-insert-paren))
  (define-key map (kbd "8") '("*" . (lambda () (interactive) (insert "*"))))
  (define-key map (kbd "7") '("&" . (lambda () (interactive) (insert "&"))))
  (define-key map (kbd "6") '("^" . (lambda () (interactive) (insert "^"))))
  (define-key map (kbd "5") '("%" . (lambda () (interactive) (insert "%"))))
  (define-key map (kbd "4") '("$" . (lambda () (interactive) (insert "$"))))
  (define-key map (kbd "3") '("#" . (lambda () (interactive) (insert "#"))))
  (define-key map (kbd "2") '("@" . (lambda () (interactive) (insert "@"))))
  (define-key map (kbd "1") '("!" . (lambda () (interactive) (insert "!"))))
  (define-key map (kbd "`") '("~" . (lambda () (interactive) (insert "~"))))
  (define-key map (kbd "a") '("A" . (lambda () (interactive) (insert "A"))))
  (define-key map (kbd "b") '("B" . (lambda () (interactive) (insert "B"))))
  (define-key map (kbd "c") '("C" . (lambda () (interactive) (insert "C"))))
  (define-key map (kbd "d") '("D" . (lambda () (interactive) (insert "D"))))
  (define-key map (kbd "e") '("E" . (lambda () (interactive) (insert "E"))))
  ;; (define-key map (kbd "f") '("F" . (lambda () (interactive) (insert "F"))))
  (define-key map (kbd "g") '("G" . (lambda () (interactive) (insert "G"))))
  (define-key map (kbd "h") '("H" . (lambda () (interactive) (insert "H"))))
  (define-key map (kbd "i") '("I" . (lambda () (interactive) (insert "I"))))
  (define-key map (kbd "j") '("J" . (lambda () (interactive) (insert "J"))))
  (define-key map (kbd "k") '("K" . (lambda () (interactive) (insert "K"))))
  (define-key map (kbd "l") '("L" . (lambda () (interactive) (insert "L"))))
  (define-key map (kbd "m") '("M" . (lambda () (interactive) (insert "M"))))
  (define-key map (kbd "n") '("N" . (lambda () (interactive) (insert "N"))))
  (define-key map (kbd "o") '("O" . (lambda () (interactive) (insert "O"))))
  (define-key map (kbd "p") '("P" . (lambda () (interactive) (insert "P"))))
  (define-key map (kbd "q") '("Q" . (lambda () (interactive) (insert "Q"))))
  (define-key map (kbd "r") '("R" . (lambda () (interactive) (insert "R"))))
  (define-key map (kbd "s") '("S" . (lambda () (interactive) (insert "S"))))
  (define-key map (kbd "t") '("T" . (lambda () (interactive) (insert "T"))))
  (define-key map (kbd "u") '("U" . (lambda () (interactive) (insert "U"))))
  (define-key map (kbd "v") '("V" . (lambda () (interactive) (insert "V"))))
  (define-key map (kbd "w") '("W" . (lambda () (interactive) (insert "W"))))
  (define-key map (kbd "x") '("X" . (lambda () (interactive) (insert "X"))))
  (define-key map (kbd "y") '("Y" . (lambda () (interactive) (insert "Y"))))
  (define-key map (kbd "z") '("Z" . (lambda () (interactive) (insert "Z")))))

(dolist (mode '(org-mode
                python-mode
                python-ts-mode
                markdown-mode
                ))
  (add-hook (intern (concat (symbol-name mode) "-hook"))
            (lambda ()
              (local-set-key (kbd ";") my/insert-char-map))))
(define-key xah-fly-insert-map (kbd "[") '("[" . xah-insert-square-bracket))

(define-key xah-fly-insert-map (kbd "[") '("[" . xah-insert-square-bracket))

(defun my/xah-insert-singe-bracket () (interactive) (xah-insert-bracket-pair "<" ">"))
(bind-key "SPC d b" #'my/xah-insert-singe-bracket 'xah-fly-command-map)


;; ;; * key bindings
;; ;; keyboard quit
(defun my/keyboard-quit ()
  (interactive)
  (cond
   ((derived-mode-p 'minibuffer-mode)
    (call-interactively #'minibuffer-keyboard-quit))
   ((derived-mode-p 'isearch-mode)
    (call-interactively #'isearch-abort))
   ;; ((and (boundp 'hydra-curr-map)
   ;;       hydra-curr-map)
   ;;  (call-interactively #'hydra-keyboard-quit))
   ((derived-mode-p 'blink-search-mode)
    (call-interactively #'blink-search-quit))
   (t
    ;; (execute-kbd-macro (read-kbd-macro "C-g"))
    (my/exeucte-key-macro "C-g")
    )))

(bind-key "<escape>" nil 'xah-fly-insert-map)
(bind-key "<escape>" nil 'xah-fly-command-map)
(bind-key "<escape>" #'my/keyboard-quit)
;; (bind-key "<escape>" nil)
;; (global-set-key (kbd "<escape>") (kbd "C-g"))
;; (key-chord-define-global "kl" #'my/keyboard-quit)
;; (key-chord-define-global "kl" (kbd "C-g"))

;; open new line
(bind-key "W" #'open-newline-above 'xah-fly-command-map)
(bind-key "R" #'open-newline-below 'xah-fly-command-map)

;; navigation
(bind-key "O" #'my/thingatpt-end-of-symbol 'xah-fly-command-map)
(bind-key "U" #'my/thingatpt-beginning-of-symbol 'xah-fly-command-map)

;; mark jump
(bind-key "0" #'back-button-local-backward 'xah-fly-command-map)
(bind-key ")" #'back-button-local-forward 'xah-fly-command-map)

;; mark
(bind-key "8" #'er/expand-region 'xah-fly-command-map)

;; bm bookmark
(bind-key "SPC e n" #'bm-next 'xah-fly-command-map)
(bind-key "SPC e p" #'bm-previous 'xah-fly-command-map)
(bind-key "SPC e t" #'bm-toggle 'xah-fly-command-map)

;; move text
(bind-key "E" #'move-text-up 'xah-fly-command-map)
(bind-key "D" #'move-text-down 'xah-fly-command-map)

;; open external
;; "SPC i w"
(bind-key [remap xah-open-in-external-app] 'my/open-file-externally)
(bind-key "SPC i W" #'my/xah-open-in-vscode 'xah-fly-command-map)

;; use `project.el'
(bind-key "SPC p" project-prefix-map xah-fly-command-map)



(defun my/iedit-smart-trigger ()
  (interactive)
  (cond (isearch-mode (iedit-mode-from-isearch))
        ;; (esc (iedit-execute-last-modification))
        ;; (help (iedit-mode-toggle-on-function))
        (t (iedit-mode))))

(require 'init-smartparens)
(require 'thing-edit)

(defvar my/xah-quit-keymap
  (let ((map (make-sparse-keymap)))

    (define-key map (kbd "q") '("exit emacs" . my/kill-emacs-save-or-server-edit))
    (define-key map (kbd "e") #'delete-window)
    (define-key map (kbd "f") #'delete-frame)
    (define-key map (kbd "w") #'quit-window)
    (define-key map (kbd "a") #'ace-delete-window)
    map)
  "my keymap for `quit'")

(defvar my/list-jump-map
  (let* ((map (make-sparse-keymap)))
    (define-key map (kbd "a") #'beginning-of-defun)
    (define-key map (kbd "g") #'end-of-defun)
    (define-key map (kbd "e") '("up->list" . (lambda (&optional arg escape-strings no-syntax-crossing)
                                               (interactive "^p\nd\nd")
                                               (cond
                                                ((eq major-mode 'python-mode) (funcall-interactively #'python-nav-backward-up-list arg))
                                                (t (funcall-interactively #'backward-up-list arg escape-strings no-syntax-crossing))))))
    (define-key map (kbd "d") '("down->list" . (lambda (&optional arg interactive)
                                                 (interactive "^p\nd")
                                                 (cond
                                                  ((eq major-mode 'python-mode) (funcall-interactively #'sp-down-sexp arg))
                                                  (t (funcall-interactively #'down-list arg interactive))))))
    (define-key map (kbd "[") #'sp-backward-sexp)
    ;; (define-key map (kbd "]") #'sp-forward-sexp)
    ;; (define-key map (kbd "i") #'sp-up-sexp)
    (define-key map (kbd ";") #'my/iedit-smart-trigger)
    map))





(bind-key "[" my/list-jump-map 'xah-fly-command-map)
(bind-key "SPC q" my/xah-quit-keymap 'xah-fly-command-map)

;; rebind original `SPC q' to `SPC e q'
(bind-key "SPC e q" #'my/format-buffer-fn 'xah-fly-command-map)

(bind-key "SPC e w" #'xah-fill-or-unfill 'xah-fly-command-map)
;; align
(bind-key "SPC e a" #'ialign 'xah-fly-command-map)
;; window resize and jump
(bind-key "SPC e o" #'resize-window 'xah-fly-command-map)

;; =[= for jump
(bind-key "] ]" 'sp-forward-sexp 'xah-fly-command-map)
;; =q= for search(query)
(bind-key "q" nil 'xah-fly-command-map)
(bind-key "q" my/search-keymap 'xah-fly-command-map)

(require 'persp-mode)
;; * `SPC i' prefix
;; revert buffer
(bind-key "SPC i r" 'revert-buffer 'xah-fly-command-map)
(bind-key "SPC i R" 'xah-open-last-closed 'xah-fly-command-map)
(bind-key "SPC i I" 'persp-switch-to-buffer 'xah-fly-command-map)
(bind-key "SPC i i" 'consult-project-buffer 'xah-fly-command-map)
(bind-key "SPC i k" 'bookmark-bmenu-list 'xah-fly-command-map)

;; major mode hydra
(bind-key "SPC SPC" #'major-mode-hydra 'xah-fly-command-map)
;; (bind-key "SPC SPC" #'(lambda ()
;;                         (interactive)
;;                         (let ((hydra (major-mode-hydra--body-name-for major-mode)))
;;                           (call-interactively hydra))) 'xah-fly-command-map)

;; mark tool
(defvar my/mark-thing-map
  nil
  "mark thing keymap")
(setq my/mark-thing-map
      (let* ((map (make-sparse-keymap)))
        (require 'expand-region)
        (define-key map (kbd "d") #'mark-defun)
        (define-key map (kbd "w") #'mark-word)
        (define-key map (kbd "s") #'mark-sexp)
        (define-key map (kbd "S") #'er/mark-symbol)
        (define-key map (kbd "p") #'mark-page)
        (define-key map (kbd "h") #'mark-paragraph)
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

;; ;; iedit fix
;; (add-hook 'iedit-mode-hook #'xah-fly-insert-mode-activate)

;; ;; multiple-cursors fix
;; (add-hook 'multiple-cursors-mode-hook #'xah-fly-insert-mode-activate)

;; ;; magit
;; (add-hook 'magit-mode-hook #'xah-fly-insert-mode-activate)
;; (add-hook 'magit-status-mode-hook #'xah-fly-insert-mode-activate)

;; vc-mode
(bind-key "SPC v" 'vc-prefix-map #'xah-fly-command-map)

;; global tools
(defvar my/global-tools-map
  (make-sparse-keymap)
  "keymap for global tools")


;; (autoload 'my/eaf-keymap "init-eaf")

(when (boundp 'my/eaf-keymap)
  (define-key my/global-tools-map (kbd "e") my/eaf-keymap))
(define-key my/global-tools-map (kbd "n") my/org-roam-keymap)
(define-key my/global-tools-map (kbd "s") my/server-keymap)
(define-key my/global-tools-map (kbd ". a") #'org-agenda)
(define-key my/global-tools-map (kbd ". c") #'cfw:open-org-calendar)

(define-key xah-fly-command-map (kbd "SPC .") my/global-tools-map)

;; * undo
(bind-key "y" #'undo-fu-only-undo 'xah-fly-command-map)
(bind-key "Y" #'undo-fu-only-redo 'xah-fly-command-map)

;; (add-hook 'blink-search-mode-hook #'xah-fly-insert-mode-activate)
(when (daemonp)
  (add-hook 'server-after-make-frame-hook #'xah-fly-command-mode-activate))


(bind-key "Q" #'my/meow-quit 'xah-fly-command-map)
(bind-key "\\" #'my/meow-quit 'xah-fly-command-map)

;; * meow related
;; (require 'meow)
;; ;; search
;; (bind-key "N" #'meow-visit 'xah-fly-command-map)
;; (bind-key "n" #'meow-search 'xah-fly-command-map)
;; ;; like meow --> ";"
;; (bind-key ":" #'meow-reverse 'xah-fly-command-map)

;; ;; * thing
;; ;; meow inner thing --> "."
;; (bind-key ">" #'meow-inner-of-thing 'xah-fly-command-map)
;; ;; meow outter thing --> ","
;; (bind-key "<" #'meow-bounds-of-thing 'xah-fly-command-map)

;; ;; till/find --> meow "t/f"
;; (bind-key "F" #'meow-find 'xah-fly-command-map)
;; (bind-key "T" #'meow-till 'xah-fly-command-map)


;; multi edit/ markmacro
(require 'markmacro)
(bind-key "SPC e ;" 'markmacro-mark-words 'xah-fly-command-map)
(bind-key "SPC e '" 'markmacro-mark-lines 'xah-fly-command-map)
(bind-key "SPC e /" 'markmacro-mark-chars 'xah-fly-command-map)
(bind-key "SPC e L" 'markmacro-mark-imenus 'xah-fly-command-map)
(bind-key "SPC e <" 'markmacro-apply-all 'xah-fly-command-map)
(bind-key "SPC e >" 'markmacro-apply-all-except-first 'xah-fly-command-map)
(bind-key "SPC e M" 'markmacro-rect-set 'xah-fly-command-map)
(bind-key "SPC e D" 'markmacro-rect-delete 'xah-fly-command-map)
(bind-key "SPC e R" 'markmacro-rect-replace 'xah-fly-command-map)
(bind-key "SPC e I" 'markmacro-rect-insert 'xah-fly-command-map)
(bind-key "SPC e C" 'markmacro-rect-mark-columns 'xah-fly-command-map)
(bind-key "SPC e S" 'markmacro-rect-mark-symbols 'xah-fly-command-map)
(bind-key "SPC e h" 'markmacro-secondary-region-set 'xah-fly-command-map)
(bind-key "SPC e H" 'markmacro-secondary-region-mark-cursors 'xah-fly-command-map)

(bind-key "SPC e m" 'vr/mc-mark 'xah-fly-command-map)

;; keypad --> god-mdoe
;; (bind-key "SPC SPC" 'god-execute-with-current-bindings 'xah-fly-command-map)

;; * rectangle
(bind-key "SPC k o" 'copy-rectangle-as-kill 'xah-fly-command-map)

;; blinksearch
(defun my/blink-search-quit-advice ()
  (interactive)
  (xah-fly-command-mode-activate))

(advice-add #'blink-search-quit :after #'my/blink-search-quit-advice)

;; * prefix argument
(bind-key "SPC j k" 'universal-argument 'xah-fly-command-map)

;; embark
(bind-key "SPC j e" 'embark-act 'xah-fly-command-map)

;; openai
(bind-key "SPC i a" my/openai-map 'xah-fly-command-map)


(defun xah--get-random-uuid ()
  "Insert a UUID.
This commands calls “uuidgen” on MacOS, Linux, and calls PowelShell on Microsoft Windows.
URL `http://xahlee.info/emacs/emacs/elisp_generate_uuid.html'
Version 2020-06-04"
  (interactive)
  (string-trim (cond
                ((string-equal system-type "windows-nt")
                 (shell-command-to-string "pwsh.exe -Command [guid]::NewGuid().toString()"))
                ((string-equal system-type "darwin") ; Mac
                 (shell-command-to-string "uuidgen"))
                ((string-equal system-type "gnu/linux")
                 (shell-command-to-string "uuidgen"))
                (t
                 ;; code here by Christopher Wellons, 2011-11-18.
                 ;; and editted Hideki Saito further to generate all valid variants for "N" in xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx format.
                 (let ((myStr (md5 (format "%s%s%s%s%s%s%s%s%s%s"
                                           (user-uid)
                                           (emacs-pid)
                                           (system-name)
                                           (user-full-name)
                                           (current-time)
                                           (emacs-uptime)
                                           (garbage-collect)
                                           (buffer-string)
                                           (random)
                                           (recent-keys)))))
                   (format "%s-%s-4%s-%s%s-%s"
                           (substring myStr 0 8)
                           (substring myStr 8 12)
                           (substring myStr 13 16)
                           (format "%x" (+ 8 (random 4)))
                           (substring myStr 17 20)
                           (substring myStr 20 32)))))))

;; wsl, paste from windows
(bind-key "SPC i v" 'my/wsl-paste 'xah-fly-command-map)

;; translate
(bind-key "SPC i a b" 'baidu-translate-zh-mark 'xah-fly-command-map)

;; async shell command (like M-&)
(bind-key "SPC l -" #'async-shell-command 'xah-fly-command-map)

;; fix pyim
(with-eval-after-load 'pyim
  (defun my/xah-fly-keys-not-insert-p ()
    (interactive)
    (and (boundp 'xah-fly-insert-state-p) (not xah-fly-insert-state-p)))
  (add-to-list 'pyim-english-input-switch-functions #'my/xah-fly-keys-not-insert-p))
(provide 'init-xah-fly-keys)
