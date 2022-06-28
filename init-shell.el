;; -*- coding: utf-8; -*-
(use-package bash-completion
  :commands (bash-completion-dynamic-complete)
  :config
  (add-hook 'shell-dynamic-complete-functions
	    'bash-completion-dynamic-complete))

(when (executable-find "fish")
  (use-package fish-completion
    :after shell
    :hook (shell-mode . global-fish-completion-mode)
    :custom
    (fish-completion-fallback-on-bash-p t))
  )

(provide 'init-shell)
