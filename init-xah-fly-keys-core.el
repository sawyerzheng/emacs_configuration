(use-package xah-fly-keys-core
  ;; :straight (xah-fly-keys :type git :host github :repo "xahlee/xah-fly-keys")
  :init
  (setq xah-fly-use-control-key nil)
  (setq xah-fly-use-meta-key nil)
  :config
  (defun xah-new-empty-buffer ()
  "Create a new empty buffer.
New buffer is named untitled, untitled<2>, etc.

On emacs quit, if you want emacs to prompt for save, set `buffer-offer-save' to t.

It returns the buffer.

URL `http://xahlee.info/emacs/emacs/emacs_new_empty_buffer.html'
Version: 2017-11-01 2022-04-05"
  (interactive)
  (let ((xbuf (generate-new-buffer "untitled")))
    (switch-to-buffer xbuf)
    (funcall (if (fboundp #'gfm-mode) #'gfm-mode initial-major-mode))
    xbuf
    ))
  (defun my/xah-insert-time ()
    "insert time %H:%M only."
    (interactive)
    (insert (format-time-string "%H:%M")))
  )

(provide 'init-xah-fly-keys-core)
