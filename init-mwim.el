(use-package mwim
  :bind (
         ("M-m" . my/mwim-begin-end-jump)
         ("M-M" . mwim-end))
  :config
  (defun my/mwim-begin-end-jump (&optional arg)
    (interactive "^P")
    (let ((positions '(
                       mwim-block-beginning
                       mwim-block-end


                       mwim-code-beginning
                       mwim-line-beginning
                       mwim-comment-beginning
                       mwim-code-end
                       mwim-line-end)))
      (mwim-move-to-next-position
       (if arg
           (reverse positions)
         positions))))
  ;; disable M-m in lispy-mode
  (with-eval-after-load 'lispy
    (define-key lispy-mode-map (kbd "M-m") nil)))


(provide 'init-mwim)
