(use-package exec-path-from-shell
  :straight t
  :commands (exec-path-from-shell-initialize
             exec-path-from-shell-copy-env))
(if my/linux-p
    (exec-path-from-shell-initialize))

(provide 'init-exec-path-from-shell)
