(defvar my/server-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "s") #'server-edit)
    (define-key map (kbd "k") #'save-buffers-kill-emacs)
    (define-key map (kbd "d") #'server-start)
    map))

(defun my/load-if-available (lib)
  (when (featurep lib)
    (require lib)))

(when (daemonp)
  ;; (add-hook 'server-switch-hook
  ;;           (lambda nil
  ;;             (let ((server-buf (current-buffer)))
  ;;               (bury-buffer)
  ;;               (switch-to-buffer server-buf)
  ;;               (if (my/regexp-full-match "[[:space:]]*\\*.+\\*[[:space:]]*" (buffer-name))
  ;;                   (progn
  ;;                     (bury-buffer)
  ;;                     (switch-to-buffer "*scratch*"))
  ;;                 ))))

  ;; for systemd
  (exec-path-from-shell-initialize)

  )

(dolist (lib '(org
               ;; jupyter
               ;; ob-async
               ;; ob-go
               ;; org-download
               ;; org-indent
               ;; org-cliplink
               ;; org-rich-yank
               ;; org-fancy-priorities
               ;; org-preview-html
               ;; org-modern
               ;; org-appear
               ;; org-modern-indent
               ;; olivetti
               ;; org-fragtog
               ;; org-pretty-table
               ox
               ;; ox-pandoc
               ;; valign
               pangu-spacing

               markdown-mode

               lisp-mode
               elisp-mode
               helpful

               embark
               corfu
               vertico
               consult

               treemacs
               projectile
               project
               ;; magit-remote
               magit
               magit-gitflow
               magit-todos
               ;; git-gutter
               ;; git-gutter-fringe
               git-timemachine
               ;; forge

               doom-modeline
               all-the-icons
               doom-themes

               lsp-bridge
               lsp-mode
               eglot
               dap-mode
               docker-tramp

               python
               code-cells

               lsp-java
               sgml-mode


               ;; eaf

               ))
  (if (featurep lib)
      (require lib)
    (require lib)
    ))

(defun my/server-open-recentf-file ()
  (interactive)
  (recentf-open-most-recent-file 1))

(add-hook 'server-after-make-frame-functions #'my/server-open-recentf-file)
(provide 'init-server)
