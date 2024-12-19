(my/straight-if-use 'ein)
(use-package ein
  :commands (ein:login                  ;; login a remote server
             ein:jupyter-server-login-and-open
             ein:jupyter-server-start   ;; start a local server
             ein:jupyter-server-stop)
  :config
  ;; (my/elpy-enable)
  (setq ein:markdown-header-scaling t)

  :pretty-hydra
  (my/ein-nav-hydra
   (:title (pretty-hydra-title "ein commands") :color pink :quit-key "q")
   ("Nav"
    (("k" ein:worksheet-goto-next-input-km "next")
     ("i" ein:worksheet-goto-prev-input-km "prev")
     ("e" ein:worksheet-move-cell-up-km "move up")
     ("o" ein:worksheet-move-cell-down-km "move down")
     ("m" ein:worksheet-merge-cell-km "merge")

     ("a" ein:worksheet-insert-cell-above-km "above")
     ("b" ein:worksheet-insert-cell-below-km "below")
     ("c" ein:worksheet-copy-cell-km "copy")
     ("x" ein:worksheet-kill-cell-km "cut")
     ("v" ein:worksheet-yank-cell-km "paste")
     ("e" ein:worksheet-execute-cell-km "eval")
     ("E" ein:worksheet-execute-cell-and-goto-next-km "S-eval")
     ))
   )
  :pretty-hydra
  (my/ein-hydra
   (:title (pretty-hydra-title "ein commands") :color blue :quit-key "q")
   ("File"
    (("f r" ein:notebook-rename-command "rename")
     ("f s" ein:notebook-save-notebook-command "save")
     ("f d" ein:notebook-save-to-command "duplicate")
     ("f R" my/ein-revert|refresh-notebook "reload")
     )
    "Cell"
    (("c a" ein:worksheet-insert-cell-above-km "above")
     ("c b" ein:worksheet-insert-cell-below-km "below")
     ("c c" ein:worksheet-copy-cell-km "copy")
     ("c x" ein:worksheet-kill-cell-km "cut")
     ("c v" ein:worksheet-yank-cell-km "paste")
     ("c m" ein:worksheet-merge-cell-km "merge")
     ("c e" ein:worksheet-execute-cell-km "eval")
     ("c s" ein:worksheet-split-cell-at-point-km "split")
     ("a" ein:worksheet-insert-cell-above-km "above")
     ("b" ein:worksheet-insert-cell-below-km "below")
     ("c" ein:worksheet-copy-cell-km "copy")
     ("x" ein:worksheet-kill-cell-km "cut")
     ("v" ein:worksheet-yank-cell-km "paste")
     ("e" ein:worksheet-execute-cell-km "eval")
     ("E" ein:worksheet-execute-cell-and-goto-next-km "S-eval")
     ("s" ein:worksheet-split-cell-at-point-km "split")
     )
    "Type"
    (("t" ein:worksheet-toggle-cell-type-km "toggle")
     )

    "Nav"
    (("n" my/ein-nav-hydra/body "nav")
     ("'" my/ein-nav-hydra/body "nav")
     ("M-'" my/ein-nav-hydra/body "nav")
     ("j" ein:worksheet-goto-next-input-km "next")
     ("l" ein:worksheet-goto-prev-input-km "prev")
     )

    "Output"
    (("o t" ein:worksheet-toggle-output-km "toggle")
     ("o d" ein:worksheet-clear-output-km "discard")
     ("o D" ein:worksheet-clear-all-output-km "Discard all")
     ("o s" ein:shared-output-show-code-cell-at-point-km "show full")
     ("o S" ein:worksheet-set-output-visibility-all-km "Show all")
     )
    "Kernel"
    (("k R" ein:notebook-restart-session-command "restart")
     ("k r" (lambda () (interactive) (ein:notebook-restart-session-command) (call-interactively #'ein:worksheet-execute-all-cells)) "restart eval all")
     ("k e" ein:worksheet-execute-all-cells "eval all")
     ("k a" ein:worksheet-execute-all-cells-above "eval above")
     ("k b" ein:worksheet-execute-all-cells-below "eval below")
     ("k i" ein:notebook-kernel-interrupt-command "interrupt")
     ("k s" ein:notebook-switch-kernel "switch")
     )
    "Misc"
    (("m t" ein:tb-show-km "traceback")
     ("/" ein:notebook-scratchsheet-open "scratch"))))
  :init
  ;; (require 'ein-notebook)
  ;; (require 'elpy)
  ;; (my/elpy-enable)
  ;; (define-key ein:notebook-mode-map (kbd "M-'") #'my/ein-hydra/body)
  :bind (:map ein:notebook-mode-map
              ("S-<return>" . ein:worksheet-execute-cell-and-goto-next-km)
              ("M-<return>" . ein:worksheet-execute-cell-and-goto-next-km)
              ("C-c C-c" . ein:worksheet-execute-cell-km)
              ("C-<return>" . ein:worksheet-execute-cell-km)
	      ("M-'" . my/ein-hydra/body)
              ))


(defun my/ein-revert|refresh-notebook ()
  "Re-open current notebook to get the latest evaluation results.
Pass `no-pop' to `ein:notebook-open' and handle displaying in the
callback."
  (interactive)
  (let* ((notebook ein:notebook)
         (wd (selected-window))
         (pos (point))
         (buffers (-keep #'ein:worksheet-buffer
                         (append (ein:$notebook-worksheets notebook)
                                 (ein:$notebook-scratchsheets notebook)))))
    (mapc 'kill-buffer buffers)
    (ein:notebook-open
     (ein:$notebook-url-or-port notebook)
     (ein:$notebook-notebook-path notebook)
     nil
     (lambda (nb _)
       (with-selected-window wd
         (switch-to-buffer (ein:notebook-buffer nb))
         (goto-char pos)))
     nil
     'no-pop)))

(provide 'init-ein)
