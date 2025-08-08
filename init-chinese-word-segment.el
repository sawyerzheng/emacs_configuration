
;; (require 'init-cns)

;; (when my/linux-p
;;   (require 'cns)
;;   (global-cns-mode))

(use-package deno-bridge-jieba
  :commands (my/deno-bridge-jieba-mode)
  :config
  (define-minor-mode my/deno-bridge-jieba-mode
    "minor mode for deno-bridge-jieba word jumping key bindings"
    :keymap (let ((map (make-sparse-keymap)))
              (define-key map [remap forward-word] 'deno-bridge-jieba-forward-word)
              (define-key map [remap backward-word] 'deno-bridge-jieba-backward-word)
              (define-key map [remap forward-kill-word] 'deno-bridge-jieba-kill-word)
              (define-key map [remap backward-kill-word] 'deno-bridge-jieba-backward-kill-word)
              map)
    )

  (define-globalized-minor-mode global-my/deno-bridge-jieba-mode
    my/deno-bridge-jieba-mode
    my/deno-bridge-jieba-auto-enable)

  (defun my/deno-bridge-jieba-auto-enable nil
    "Enable `cns-mode' if current buffer contaions HànZì."
    (if (string-match "\\cC" (buffer-string))
        (my/deno-bridge-jieba-mode 1))))

(defun my/deno-bridge-jieba--chinese-or-word-bounds ()
  (let* (begin
         end
         (bounds (bounds-of-thing-at-point 'word))
         ;;save states
         (original-point (point))
         (original-mark (and (mark t) (mark t))))
    (when bounds
      (setq begin (car bounds)
            end (cdr bounds)))
    (when deno-bridge-app-list
      ;; (deno-bridge-call-jieba-on-current-line "mark-word")
      ;; (when (region-active-p)
      ;;   (setq begin (region-beginning)
      ;;         end (region-end))
      ;;   )
      (save-mark-and-excursion
        ;; (call-interactively #'deno-bridge-jieba-forward-word)
        ;; (message "point: %s" (point))
        ;; (call-interactively #'deno-bridge-jieba-backward-word)
        ;; (message "point: %s" (point))

        (setq-local begin (point))
        (message "point: %s" (point))

        (call-interactively #'deno-bridge-jieba-forward-word)
        (setq-local end (point))
        (message "point: %s" (point))


        )
      ;; (deactivate-mark t)
      ;; restore mark and point
      ;; (when original-mark
      ;;   (set-mark original-mark))
      ;; (message "%s" original-point)
      ;; (goto-char original-point)
      )

    ;; return
    (if (and begin end)
        (list begin end)
      nil)
    ))

(add-hook 'my/startup-hook #'(lambda ()
                               (when (executable-find "deno")
                                 (require 'deno-bridge-jieba)
                                 (global-my/deno-bridge-jieba-mode))))


(provide 'init-chinese-word-segment)
