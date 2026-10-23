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
      ;; (funcall (if (fboundp #'gfm-mode) #'gfm-mode initial-major-mode))
      (funcall initial-major-mode)
      xbuf
      ))
  (defun my/xah-insert-time ()
    "insert time %H:%M only."
    (interactive)
    (insert (format-time-string "%H:%M")))

  ;; 让 `xah-open-file-at-cursor' 识别 org 的 ~路径~ 与 =路径= 标记：
  ;; 光标位于 ~./foo.org~ 内时，用标记内部的路径打开文件，
  ;; 而不是把包裹的 `~' 当成文件名的一部分。
  (defun my/xah-open-file-at-cursor-org-code-advice (orig &rest args)
    "在 org 的 ~...~ 或 =...= 内部时，以标记内的内容作为路径调用 ORIG。"
    (let* ((ctx (and (derived-mode-p 'org-mode)
                     (not (region-active-p))
                     (fboundp 'org-element-context)
                     (ignore-errors (org-element-context))))
           ;; code/verbatim 对象没有 :contents-begin，只有 :begin/:end/:value，
           ;; 因此从两端各去掉一个标记字符（~ 或 =）。
           (beg (and ctx
                     (memq (org-element-type ctx) '(code verbatim))
                     (1+ (org-element-property :begin ctx))))
           (end (and beg
                     (- (org-element-property :end ctx) 1
                        (or (org-element-property :post-blank ctx) 0))))
           (buf (current-buffer)))
      (if (not (and beg end (< beg end)))
          (apply orig args)
        (unwind-protect
            (progn
              (set-mark beg)
              (goto-char end)
              (activate-mark)
              (apply orig args))
          (with-current-buffer buf
            (deactivate-mark))))))

  (advice-add #'xah-open-file-at-cursor :around
              #'my/xah-open-file-at-cursor-org-code-advice)
  )

(provide 'init-xah-fly-keys-core)
