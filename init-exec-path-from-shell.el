(my/straight-if-use 'exec-path-from-shell)
(use-package exec-path-from-shell
  :commands (exec-path-from-shell-initialize
             exec-path-from-shell-copy-env))
;; (if my/linux-p
;;     (run-with-timer 4 1 (lambda () (exec-path-from-shell-initialize)))
;;   )

(provide 'init-exec-path-from-shell)
