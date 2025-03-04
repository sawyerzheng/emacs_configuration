;; -*- coding: utf-8; -*-
(my/straight-if-use 'bash-completion)
(use-package bash-completion
  :commands (bash-completion-dynamic-complete)
  :config
  (add-hook 'shell-dynamic-complete-functions
	    'bash-completion-dynamic-complete))

(my/straight-if-use 'fish-mode)
(use-package fish-mode
  :if (executable-find "fish")
  :commands (fish-mode)
  :mode (("\\.fish\\'" . fish-mode)
         ("/fish_funced\\..*\\'" . fish-mode)))

;; (use-package fish-completion
;;   :after shell
;;   :hook (shell-mode . global-fish-completion-mode)
;;   :custom
;;   (fish-completion-fallback-on-bash-p t))


(my/straight-if-use 'vterm)
(use-package vterm
  :if (not my/windows-p)
  :commands (vterm vterm-module-compile)
  :config
  :custom (vterm-always-compile-module t)
  )

(my/straight-if-use 'pcmpl-args)

(my/straight-if-use '(eat :type git :host codeberg :repo "akib/emacs-eat" :files ("*.el" ("term" "term/*.el") "*.texi"
										  "*.ti" ("terminfo/e" "terminfo/e/*")
										  ("terminfo/65" "terminfo/65/*")
										  ("integration" "integration/*")
										  (:exclude ".dir-locals.el" "*-tests.el"))))
(use-package eat
  :commands (eat eat-other-window)
  :config
  ;; * hack for doom theme
  ;; ** doom-vibrant
  ;; change base0 first element to #555f70
  (with-eval-after-load 'ace-window
    (define-key eat-semi-char-mode-map (kbd "M-o") #'ace-window)
    (define-key eat-semi-char-mode-map (kbd "M-O") #'ace-swap-window)
    )
  )

(provide 'init-shell)
