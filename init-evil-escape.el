;; copy from doom emacs
(use-package evil-escape
  :straight t  
  :hook (evil-mode . evil-escape-mode)
  :init
  (setq evil-escape-excluded-states '(normal visual multiedit emacs motion)
        evil-escape-excluded-major-modes '(neotree-mode treemacs-mode vterm-mode)
        evil-escape-key-sequence "jk"
        evil-escape-delay 0.25)
  :config
  (evil-define-key* '(insert replace visual operator) 'global "\C-g" #'evil-escape)
  ;; `evil-escape' in the minibuffer is more disruptive than helpful. That is,
  ;; unless we have `evil-collection-setup-minibuffer' enabled, in which case we
  ;; want the same behavior in insert mode as we do in normal buffers.
  (defun +evil-inhibit-escape-in-minibuffer-fn ()
    (and (minibufferp)
         (or (not (bound-and-true-p evil-collection-setup-minibuffer))
             (evil-normal-state-p))))
  (add-hook 'evil-escape-inhibit-functions #'+evil-inhibit-escape-in-minibuffer-fn))


(provide 'init-evil-escape)
