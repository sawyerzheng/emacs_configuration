(use-package consult
  :straight t
  :commands (consult-line)
  :bind
  (("C-c f r" . consult-recent-file)
   ("C-c f f" . consult-find)

   ("C-c o e" . consult-file-externally)

   ("C-c s s" . +default/search-buffer) ;; use `consult-line' as backend
   ("C-c s p" . consult-ripgrep)
   ("C-c s g" . consult-git-grep)
   ("C-c s f" . consult-find)
   ("C-c s i" . consult-imenu) ;; search items (function, class) with imenu
   ("C-c s I" . consult-imenu-multi) ;; imenu in all project buffers

   ("C-c b b" . consult-buffer)
   ("C-c b i" . consult-imenu)
   ("C-h t" . consult-theme)

   ;; ("C-c o e" . consult-file-externally)

   ;; * buffer switch
   ;; any
   ([remap switch-to-buffer] . consult-buffer)
   ;; in project
   ([remap projectile-switch-to-buffer] . consult-project-buffer)

   ([remap goto-line] . consult-goto-line))
  :init
  ;; copy and modified code from doom-emacs
  (defun +default/search-buffer ()
    "Conduct a text search on the current buffer.

If a selection is active and multi-line, perform a search restricted to that
region.

If a selection is active and not multi-line, use the selection as the initial
input and search the whole buffer for it."
    (interactive)
    (let (start end multiline-p)
      (save-restriction
        (when (region-active-p)
          (setq start (region-beginning)
                end (region-end)
                multiline-p (/= (line-number-at-pos start)
                                (line-number-at-pos end)))
          (deactivate-mark)
          (when multiline-p
            (narrow-to-region start end)))
        (if (and start end (not multiline-p))
            (consult-line
             (replace-regexp-in-string
              " " "\\\\ "
              (rxt-quote-pcre
               (buffer-substring-no-properties start end))))
          (call-interactively #'consult-line))))))



(use-package window
  :straight (:type built-in)
  :bind (("C-c b x" . my/switch-to-scratch-fn)
         ("C-c b p" . switch-to-prev-buffer)
         ("C-c b n" . switch-to-next-buffer))
  :init
  (defun my/switch-to-scratch-fn ()
    (interactive) (switch-to-buffer "*scratch*")))

(use-package files
  :straight (:type built-in)
  :bind
  ("C-c b r" . revert-buffer)
  ("C-c b s" . save-buffer))

(use-package frame
  :straight (:type built-in)  
  :bind
  ("C-c o f" . make-frame-command))

(provide 'init-consult)
