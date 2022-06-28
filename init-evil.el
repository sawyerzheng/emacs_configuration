;; -*- coding: utf-8; -*-

(use-package evil
  :straight t
  :commands (evil-mode)
  :init
  (require 'init-evil-escape)
  (defvar evil-want-C-g-bindings t)
  (defvar evil-want-C-i-jump nil)       ; we do this ourselves
  (defvar evil-want-C-u-scroll t) ; moved the universal arg to <leader> u
  (defvar evil-want-C-u-delete t)
  (defvar evil-want-C-w-scroll t)
  (defvar evil-want-C-w-delete t)
  (defvar evil-want-Y-yank-to-eol t)
  (defvar evil-want-abbrev-expand-on-insert-exit nil)
  (defvar evil-respect-visual-line-mode nil)

  ;; :preface
  (defun +evil-emacs-cursor-fn ()
    (evil-set-cursor-color (get 'cursor 'evil-emacs-color)))
  (setq evil-ex-search-vim-style-regexp t
        evil-ex-visual-char-range t     ; column range for ex commands
        evil-mode-line-format 'nil
        ;; more vim-like behavior
        evil-symbol-word-search t
        ;; if the current state is obvious from the cursor's color/shape, then
        ;; we won't need superfluous indicators to do it instead.
        evil-default-cursor '+evil-default-cursor-fn
        evil-normal-state-cursor 'box
        evil-emacs-state-cursor  '(box +evil-emacs-cursor-fn)
        evil-insert-state-cursor 'bar
        evil-visual-state-cursor 'hollow
        evil-motion-state-cursor 'box
        ;; Only do highlighting in selected window so that Emacs has less work
        ;; to do highlighting them all.
        evil-ex-interactive-search-highlight 'selected-window
        ;; It's infuriating that innocuous "beginning of line" or "end of line"
        ;; errors will abort macros, so suppress them:
        evil-kbd-macro-suppress-motion-error t
        evil-undo-system 'undo-redo)

  ;; :bind
  ;; (:map evil-normal-state-map
  ;;       ("<leader>h k" . describe-key)
  ;;       ("<leader>h v" . describe-variable)
  ;;       ("<leader>h m" . describe-mode)
  ;;       ("<leader>h i" . info)
  ;; )

  :config
  (setq-hook 'magit-mode-hook evil-ex-hl-update-delay 0.25)
  (setq-hook 'so-long-minor-mode-hook evil-ex-hl-update-delay 0.25)

  ;; set leader key in all states
  (evil-set-leader nil (kbd "C-SPC"))

  ;; set leader key in normal state
  (evil-set-leader 'normal (kbd "SPC"))

  ;; set local leader
  (evil-set-leader 'normal (kbd "<leader> m") t)
  (evil-define-key 'normal 'global
                   (kbd "<leader>fs") 'save-buffer
                   (kbd "<leader>hk") 'describe-key
                   (kbd "<leader>hv") 'describe-variable
                   (kbd "<leader>hm") 'describe-mode)

  (evil-define-key '(normal visual) 'global
                   (kbd "gc") 'evilnc-comment-operator)

  ;; (general-create-definer my-leader-def
  ;;   ;; set <leader>
  ;;   :prefix "SPC")

  ;; (my-leader-def
  ;;  :keymaps 'normal
  ;;  :prefix "h"
  ;;  "k" 'describe-key
  ;;  "v" 'describe-variable
  ;;  "m" 'describe-mode
  ;; "i" 'info)



  (use-package evil-nerd-commenter
    :straight t    
    :commands (evilnc-comment-operator
               evilnc-inner-comment
               evilnc-outer-commenter)

    :general ([remap comment-line] #'evilnc-comment-or-uncomment-lines))
  )

(provide 'init-evil)
